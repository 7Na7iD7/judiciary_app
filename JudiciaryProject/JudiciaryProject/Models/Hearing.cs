using System;

namespace JudiciaryApi.Models
{
    public class Hearing
    {
        public int HearingID { get; set; }
        public int CaseID { get; set; }
        public DateTime HearingDate { get; set; }
        public string? HearingType { get; set; }
        public string? Result { get; set; }
        public DateTime? NextHearingDate { get; set; }
        
        public Case? Case { get; set; }
    }
}
