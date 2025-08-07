namespace YolkPokemon.Models.DTOs
{
    public class PokemonDto
    {
        public string Name { get; set; } = null!;

        public int Level { get; set; }

        public int TypeId { get; set; }

        public int Health { get; set; }

        public DateTime? CaughtAt { get; set; }
    }
}
