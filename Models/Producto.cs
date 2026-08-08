using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProyectoRazorProductos.Models;

public class Producto
{
    public int Id { get; set; }

    [Required(ErrorMessage = "El nombre es obligatorio")]
    [StringLength(80, ErrorMessage = "El nombre no puede superar 80 caracteres")]
    public string Nombre { get; set; } = string.Empty;

    [Required(ErrorMessage = "El precio es obligatorio")]
    [Column(TypeName = "decimal(18,2)")]
    [Range(1, 9999999, ErrorMessage = "El precio debe ser mayor a cero")]
    public decimal Precio { get; set; }

    [StringLength(200, ErrorMessage = "La descripción no puede superar 200 caracteres")]
    public string? Descripcion { get; set; }

    public bool Activo { get; set; } = true;

    public int CategoriaId { get; set; }

    public Categoria? Categoria { get; set; }

    public DateTime FechaCreacion { get; set; } = DateTime.Now;
}
