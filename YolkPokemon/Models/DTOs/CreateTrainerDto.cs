namespace YolkPokemon.Models.DTOs
{
    public class CreateTrainerDto
    {
        public string Name { get; set; } = string.Empty;
        public string Region { get; set; } = string.Empty;
        public int Age { get; set; }

        // List of Pokemon IDs to associate with the trainer
        public List<int>? PokemonIds { get; set; }
    }
}
