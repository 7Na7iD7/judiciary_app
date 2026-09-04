using System;

namespace JudiciaryApi.Models
{
    public class Case
    {
        public int CaseID { get; set; }
        public string CaseNumber { get; set; } = string.Empty;
        public string CaseTitle { get; set; } = string.Empty;
        public int CourtID { get; set; }
        public int ProsecutorID { get; set; }
        public string? CaseType { get; set; }
        public DateTime RegisterDate { get; set; }
        public string CaseStatus { get; set; } = "در جریان";
        public string? Description { get; set; }
        
        // Navigation Properties
        public Court? Court { get; set; }
        public Prosecutor? Prosecutor { get; set; }
    }
}
