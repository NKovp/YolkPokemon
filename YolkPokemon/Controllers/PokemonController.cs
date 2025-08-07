using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using YolkPokemon.Database;
using YolkPokemon.Models;
using YolkPokemon.Models.DTOs;

namespace YolkPokemon.Controllers
{
    [ApiController]
    [Route("api")]
    public class PokemonController : Controller
    {
        private readonly AppDbContext _dbContext;

        public PokemonController(AppDbContext context)
        {
            _dbContext = context;
        }


        // Health check
        [HttpGet("health")]
        public IActionResult HealthCheck()
        {
            try
            {
                // Check database connection
                var canConnect = _dbContext.Database.CanConnect();
                return Ok(new { status = "Healthy", db = canConnect });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { status = "Unhealthy", error = ex.Message });
            }
        }

        /// <summary>
        /// Adds a new pokemon to the specified trainer.
        /// </summary>
        /// <param name="trainerId"></param>
        /// <param name="dto">New Pokemon</param>
        /// <returns></returns>
        [HttpPost("trainers/{trainerId}/pokemon")]
        public async Task<IActionResult> AddPokemon(int trainerId, [FromBody] PokemonDto dto)
        {
            var trainer = await _dbContext.Trainers.FindAsync(trainerId);
            if (trainer == null)
                return NotFound(new { success = false, statusCode = 404, message = "Trainer not found" });

            var pokemon = new Pokemon
            {
                Name = dto.Name,
                Level = dto.Level,
                TypeId = dto.TypeId,
                Health = dto.Health,
                CaughtAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified),
            };

            pokemon.Owner = trainer;

            _dbContext.Pokemons.Add(pokemon);
            await _dbContext.SaveChangesAsync();

            return Ok(new { success = true, statusCode = 200, message = "Pokemon added", data = pokemon });
        }

        /// <summary>
        /// Add an existing pokemon to specified trainer
        /// </summary>
        /// <param name="trainerId"></param>
        /// <param name="pokemonId"></param>
        /// <returns></returns>
        [HttpPost("trainers/{trainerId}/pokemon/{pokemonId}")]
        public async Task<IActionResult> AddPokemonById(int trainerId, int pokemonId)
        {
            var trainer = await _dbContext.Trainers.FindAsync(trainerId);
            if (trainer == null)
                return NotFound(new { success = false, statusCode = 404, message = "Trainer not found" });

            var pokemon = await _dbContext.Pokemons.FindAsync(pokemonId);
            if (pokemon == null)
                return NotFound(new { success = false, statusCode = 404, message = "Pokemon not found" });

            pokemon.Owner = trainer;
            await _dbContext.SaveChangesAsync();

            return Ok(new { success = true, statusCode = 200, message = "Pokemon added", data = pokemon });
        }

        [HttpGet("pokemon")]
        public async Task<IActionResult> GetAllPokemon()
        {
            var pokemons = await _dbContext.Pokemons.ToListAsync();
            return Ok(new { success = true, statusCode = 200, message = "All pokemons", data = pokemons });
        }

        /// <summary>
        /// Search pokemons by criteria
        /// </summary>
        /// <param name="name"></param>
        /// <param name="typeId"></param>
        /// <param name="minLevel"></param>
        /// <param name="maxLevel"></param>
        /// <param name="trainerRegion"></param>
        /// <returns></returns>
        [HttpGet("pokemon/search")]
        public async Task<IActionResult> SearchPokemon(
            [FromQuery] string? name,
            [FromQuery] int? typeId,
            [FromQuery] int? minLevel,
            [FromQuery] int? maxLevel,
            [FromQuery] string? trainerRegion)
        {
            var query = _dbContext.Pokemons
                .Include(p => p.Type)
                .Include(p => p.Owner)
                .AsQueryable();

            if (!string.IsNullOrEmpty(name))
                query = query.Where(p => EF.Functions.ILike(p.Name, $"%{name}%"));

            if (typeId.HasValue)
                query = query.Where(p => p.TypeId == typeId);

            if (minLevel.HasValue)
                query = query.Where(p => p.Level >= minLevel);

            if (maxLevel.HasValue)
                query = query.Where(p => p.Level <= maxLevel);

            if (!string.IsNullOrEmpty(trainerRegion))
                query = query.Where(p => p.Owner!.Region == trainerRegion);

            var total = await query.CountAsync();

            var pokemons = await query.ToListAsync();

            return Ok(new
            {
                success = true,
                statusCode = 200,
                message = $"Total pokemons found: {total}",
                data = pokemons
            });
        }
    }
}
