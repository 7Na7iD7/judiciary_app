namespace JudiciaryApi.Models
{
    public class Prosecutor
    {
        public int ProsecutorID { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string NationalCode { get; set; } = string.Empty;
        public string? Phone { get; set; }
        public string? Email { get; set; }
        public string? Specialty { get; set; }
        public string? LicenseNumber { get; set; }
    }
}
