using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YolkPokemon.Database;
using YolkPokemon.Models;
using YolkPokemon.Models.DTOs;

namespace YolkPokemon.Controllers
{
    [ApiController]
    [Route("api/trainers")]
    public class TrainersController : Controller
    {
        private readonly AppDbContext _dbContext;

        public TrainersController(AppDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        /// <summary>
        /// Creates a new trainer with pokemon list.
        /// </summary>
        /// <param name="dto">Trainer details</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<IActionResult> CreateTrainer([FromBody] CreateTrainerDto dto)
        {
            // Validate required data
            if (dto == null || string.IsNullOrEmpty(dto.Name))
            {
                return BadRequest(new
                {
                    success = false,
                    statusCode = 400,
                    message = "Data is invalid!"
                });
            }

            // Create trainer
            var trainer = new Trainer
            {
                Name = dto.Name,
                Region = dto.Region,
                Age = dto.Age,
                CreatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified),
                Wins = 0,
                Losses = 0
            };

            // If pokemons are provided, create relationships
            if (dto.PokemonIds != null && dto.PokemonIds.Any())
            {
                var pokemons = await _dbContext.Pokemons
                    .Where(p => dto.PokemonIds.Contains(p.Id))
                    .ToListAsync();

                foreach (var p in pokemons)
                {
                    p.Owner = trainer;
                }
            }

            _dbContext.Trainers.Add(trainer);
            await _dbContext.SaveChangesAsync();

            return Ok(new { success = true, statusCode = 200, message = "Trainer created", data = trainer });
        }

        [HttpGet]
        public async Task<IActionResult> GetAllTrainers()
        {
            var trainers = await _dbContext.Trainers.ToListAsync();
            return Ok(new { success = true, statusCode = 200, message = "All trainers", data = trainers });
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetTrainer(int id)
        {
            var trainer = await _dbContext.Trainers.Include(t => t.Pokemons).FirstOrDefaultAsync(t => t.Id == id);
            if (trainer == null)
                return NotFound(new { success = false, statusCode = 404, message = "Trainer not found" });

            return Ok(new { success = true, statusCode = 200, message = "Trainer found", data = trainer });
        }

        /// <summary>
        /// Update an existing trainer's details.
        /// </summary>
        /// <param name="id">Trainer Id</param>
        /// <param name="dto">Trainer DTO</param>
        /// <returns></returns>
        [HttpPatch("{id}")]
        public async Task<IActionResult> UpdateTrainer(int id, [FromBody] UpdateTrainerDto dto)
        {
            var trainer = await _dbContext.Trainers.FindAsync(id);
            if (trainer == null)
                return NotFound(new { success = false, statusCode = 404, message = "Trainer not found" });

            trainer.Name = dto.Name;
            trainer.Region = dto.Region;
            trainer.Age = dto.Age;

            await _dbContext.SaveChangesAsync();

            return Ok(new { success = true, statusCode = 200, message = "Trainer updated", data = trainer });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTrainer(int id)
        {
            var trainer = await _dbContext.Trainers.FindAsync(id);
            if (trainer == null)
                return NotFound(new { success = false, statusCode = 404, message = "Trainer not found" });

            _dbContext.Trainers.Remove(trainer);
            await _dbContext.SaveChangesAsync();

            return Ok(new { success = true, statusCode = 200, message = "Trainer deleted" });
        }
    }
}
