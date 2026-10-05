namespace WebBanSachNhaGiaKim.Models;

public class Order
{
    public int Id { get; set; }
    public int BookId { get; set; }
    public Book? Book { get; set; }
    public string CustomerName { get; set; } = "";
    public string Phone { get; set; } = "";
    public string Address { get; set; } = "";
    public int Quantity { get; set; } = 1;
    public decimal Total { get; set; }
    public string Status { get; set; } = "Mới";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
