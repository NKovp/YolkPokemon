using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YolkPokemon.Database;
using YolkPokemon.Models;

namespace YolkPokemon.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;
        private readonly AppDbContext _dbContext;

        public WeatherForecastController(ILogger<WeatherForecastController> logger, AppDbContext dbContext)
        {
            _logger = logger;
            _dbContext = dbContext;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllElements()
        {
            var elements = await _dbContext.Elements.ToListAsync();
            return Ok(new { success = true, statusCode = 200, message = "All trainers", data = elements });
        }
    }
}
