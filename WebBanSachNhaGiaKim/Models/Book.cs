namespace WebBanSachNhaGiaKim.Models;

public class Book
{
    public int Id { get; set; }
    public string Title { get; set; } = "";
    public string Author { get; set; } = "";
    public string? Translator { get; set; }
    public string? Publisher { get; set; }
    public int Pages { get; set; }
    public decimal Price { get; set; }
    public decimal? OldPrice { get; set; }
    public string Description { get; set; } = "";
    public string Quote { get; set; } = "";
    public string CoverImage { get; set; } = "";
    public string? BackImage { get; set; }
}
