using ProyectoRazorProductos.Models;

namespace ProyectoRazorProductos.Services;

public class ProductoStore
{
    private readonly List<Producto> _productos = new()
    {
        new Producto
        {
            Id = 1,
            Nombre = "Mouse inalámbrico",
            Precio = 8500,
            Descripcion = "Mouse óptico para oficina",
            Activo = true
        },
        new Producto
        {
            Id = 2,
            Nombre = "Teclado mecánico",
            Precio = 32500,
            Descripcion = "Teclado con iluminación",
            Activo = true
        },
        new Producto
        {
            Id = 3,
            Nombre = "Monitor 24 pulgadas",
            Precio = 95000,
            Descripcion = "Monitor Full HD",
            Activo = false
        }
    };

    public List<Producto> ObtenerTodos()
    {
        return _productos.OrderBy(p => p.Id).ToList();
    }

    public Producto? ObtenerPorId(int id)
    {
        return _productos.FirstOrDefault(p => p.Id == id);
    }

    public void Agregar(Producto producto)
    {
        producto.Id = _productos.Any() ? _productos.Max(p => p.Id) + 1 : 1;
        producto.FechaCreacion = DateTime.Now;
        _productos.Add(producto);
    }

    public void Actualizar(Producto producto)
    {
        var actual = ObtenerPorId(producto.Id);

        if (actual is null)
        {
            return;
        }

        actual.Nombre = producto.Nombre;
        actual.Precio = producto.Precio;
        actual.Descripcion = producto.Descripcion;
        actual.Activo = producto.Activo;
    }

    public void Eliminar(int id)
    {
        var producto = ObtenerPorId(id);

        if (producto is not null)
        {
            _productos.Remove(producto);
        }
    }
}
