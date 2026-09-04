using System;

namespace JudiciaryApi.Models
{
    public class CasePerson
    {
        public int CasePersonID { get; set; }
        public int CaseID { get; set; }
        public int PersonID { get; set; }
        public string? Role { get; set; }
        public DateTime JoinDate { get; set; }
        public string? Notes { get; set; }
        
        // Navigation Properties
        public Case? Case { get; set; }
        public Person? Person { get; set; }
    }
}
