namespace JudiciaryApi.Models
{
    public class Person
    {
        public int PersonID { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string NationalCode { get; set; } = string.Empty;
        public string? Phone { get; set; }
        public string? Address { get; set; }
        public string? PersonType { get; set; }
    }
}
