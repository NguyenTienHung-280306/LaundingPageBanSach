using Microsoft.AspNetCore.Mvc;

namespace WebBanSachNhaGiaKim.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
