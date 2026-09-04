using Microsoft.EntityFrameworkCore;
using JudiciaryApi.Data;
using JudiciaryApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapGet("/test-db", async (AppDbContext db) =>
{
    var canConnect = await db.Database.CanConnectAsync();
    return canConnect ? "Database Connected ✅" : "Database Not Connected ❌";
});

app.MapGet("/courts", async (AppDbContext db) =>
    await db.Courts.ToListAsync());

app.MapPost("/courts", async (AppDbContext db, Court court) =>
{
    db.Courts.Add(court);
    await db.SaveChangesAsync();
    return Results.Created($"/courts/{court.CourtID}", court);
});

app.MapGet("/prosecutors", async (AppDbContext db) =>
    await db.Prosecutors.ToListAsync());

app.MapPost("/prosecutors", async (AppDbContext db, Prosecutor prosecutor) =>
{
    db.Prosecutors.Add(prosecutor);
    await db.SaveChangesAsync();
    return Results.Created($"/prosecutors/{prosecutor.ProsecutorID}", prosecutor);
});

app.MapGet("/cases", async (AppDbContext db) =>
{
    var cases = await db.Cases
        .Select(c => new
        {
            c.CaseID,
            c.CaseNumber,
            c.CaseTitle,
            c.CourtID,
            CourtName = db.Set<Court>()
                .Where(co => co.CourtID == c.CourtID)
                .Select(co => co.CourtName)
                .FirstOrDefault(),
            c.ProsecutorID,
            ProsecutorName = db.Set<Prosecutor>()
                .Where(p => p.ProsecutorID == c.ProsecutorID)
                .Select(p => p.FullName)
                .FirstOrDefault(),
            c.CaseType,
            c.RegisterDate,
            c.CaseStatus,
            c.Description
        })
        .ToListAsync();
    
    return Results.Ok(cases);
});

app.MapPost("/cases", async (AppDbContext db, Case caseItem) =>
{
    db.Cases.Add(caseItem);
    await db.SaveChangesAsync();
    return Results.Created($"/cases/{caseItem.CaseID}", caseItem);
});

app.MapGet("/persons", async (AppDbContext db) =>
    await db.Persons.ToListAsync());

app.MapPost("/persons", async (AppDbContext db, Person person) =>
{
    db.Persons.Add(person);
    await db.SaveChangesAsync();
    return Results.Created($"/persons/{person.PersonID}", person);
});

app.MapGet("/persons/by-nationalcode/{nationalCode}", async (AppDbContext db, string nationalCode) =>
{
    var person = await db.Persons.FirstOrDefaultAsync(p => p.NationalCode == nationalCode);
    return person != null ? Results.Ok(person) : Results.NotFound();
});

app.MapGet("/casepersons", async (AppDbContext db) =>
{
    var casePersons = await db.CasePersons
        .Include(cp => cp.Person)
        .Include(cp => cp.Case)
        .Select(cp => new
        {
            cp.CasePersonID,
            cp.CaseID,
            cp.PersonID,
            PersonName = cp.Person != null ? cp.Person.FullName : null,
            CaseTitle = cp.Case != null ? cp.Case.CaseTitle : null,
            CaseNumber = cp.Case != null ? cp.Case.CaseNumber : null,
            cp.Role,
            cp.JoinDate,
            cp.Notes
        })
        .ToListAsync();
    return Results.Ok(casePersons);
});

app.MapPost("/casepersons", async (AppDbContext db, CasePerson casePerson) =>
{
    db.CasePersons.Add(casePerson);
    await db.SaveChangesAsync();
    return Results.Created($"/casepersons/{casePerson.CasePersonID}", casePerson);
});

app.MapGet("/hearings", async (AppDbContext db) =>
{
    var hearings = await db.Hearings
        .Include(h => h.Case)
        .Select(h => new
        {
            h.HearingID,
            h.CaseID,
            CaseNumber = h.Case != null ? h.Case.CaseNumber : null,
            CaseTitle = h.Case != null ? h.Case.CaseTitle : null,
            h.HearingDate,
            h.HearingType,
            h.Result,
            h.NextHearingDate
        })
        .ToListAsync();
    return Results.Ok(hearings);
});

app.MapPost("/hearings", async (AppDbContext db, Hearing hearing) =>
{
    db.Hearings.Add(hearing);
    await db.SaveChangesAsync();
    return Results.Created($"/hearings/{hearing.HearingID}", hearing);
});

app.MapGet("/dashboard-stats", async (AppDbContext db) =>
{
    var totalCases = await db.Cases.CountAsync();
    var activeCases = await db.Cases.CountAsync(c => c.CaseStatus == "در جریان");
    var closedCases = await db.Cases.CountAsync(c => c.CaseStatus == "بسته شده");
    var totalPersons = await db.Persons.CountAsync();
    var totalProsecutors = await db.Prosecutors.CountAsync();
    var totalHearings = await db.Hearings.CountAsync();

    return Results.Ok(new
    {
        TotalCases = totalCases,
        ActiveCases = activeCases,
        ClosedCases = closedCases,
        TotalPersons = totalPersons,
        TotalProsecutors = totalProsecutors,
        TotalHearings = totalHearings
    });
});

app.Run();
