namespace JudiciaryApi.Models
{
    public class Court
    {
        public int CourtID { get; set; }
        public string CourtName { get; set; } = string.Empty;
        public string? CourtType { get; set; }
        public string? Address { get; set; }
        public string? Phone { get; set; }
    }
}
