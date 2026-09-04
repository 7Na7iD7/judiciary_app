using Microsoft.EntityFrameworkCore;
using JudiciaryApi.Models;

namespace JudiciaryApi.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Prosecutor> Prosecutors { get; set; }
        public DbSet<Court> Courts { get; set; }
        public DbSet<Case> Cases { get; set; }
        public DbSet<Person> Persons { get; set; }
        public DbSet<CasePerson> CasePersons { get; set; }
        public DbSet<Hearing> Hearings { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Prosecutor>().ToTable("Prosecutors");
            modelBuilder.Entity<Court>().ToTable("Courts");
            modelBuilder.Entity<Case>().ToTable("Cases");
            modelBuilder.Entity<Person>().ToTable("Persons");
            modelBuilder.Entity<CasePerson>().ToTable("CasePersons");
            modelBuilder.Entity<Hearing>().ToTable("Hearings");
        }
    }
}
