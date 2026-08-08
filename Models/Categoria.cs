using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProyectoRazorProductos.Models
{
    public class Categoria
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "El nombre de la categoría es obligatorio")]
        [StringLength(80, ErrorMessage = "El nombre no puede superar los 80 caracteres")]
        public string Nombre { get; set; } = string.Empty;

        [StringLength(150, ErrorMessage = "La descripción no puede superar los 150 caracteres"  )]
        public string? Descripcion { get; set; }

        public bool Activa { get; set; } = true;

        public ICollection<Producto> Productos { get; set; } = new List<Producto>();
    }
}
