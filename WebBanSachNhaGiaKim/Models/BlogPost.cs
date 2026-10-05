namespace WebBanSachNhaGiaKim.Models;

public class BlogPost
{
    public int Id { get; set; }
    public string Tag { get; set; } = "";
    public string Title { get; set; } = "";
    public string Excerpt { get; set; } = "";
    public string Content { get; set; } = "";
    public string Image { get; set; } = "";
    public int ReadMinutes { get; set; }
    public DateTime PublishedAt { get; set; }
    public bool IsFeatured { get; set; }
    public string Author { get; set; } = "";
    public double? ScoreInspire { get; set; }
    public double? ScoreStyle { get; set; }
    public double? ScoreDepth { get; set; }
    public double? ScoreReadable { get; set; }
}
