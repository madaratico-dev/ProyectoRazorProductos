using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProyectoRazorProductos.Data;
using ProyectoRazorProductos.Models;
using ProyectoRazorProductos.Services;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ProyectoRazorProductos.Controllers;
public class ProductosController : Controller
{
    private readonly ApplicationDbContext _context;

    public ProductosController(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IActionResult> Index(string? buscar)
    {
        IQueryable<Producto> consulta = _context.Productos
            .Include(p => p.Categoria);

        if (!string.IsNullOrWhiteSpace(buscar))
        {
            string termino = buscar.Trim();

            consulta = consulta.Where(p =>
                p.Nombre.Contains(termino) ||
                (p.Descripcion != null &&
                 p.Descripcion.Contains(termino)) ||
                (p.Categoria != null &&
                 p.Categoria.Nombre.Contains(termino)));
        }

        ViewData["Buscar"] = buscar;

        var productos = await consulta
            .OrderBy(p => p.Nombre)
            .ToListAsync();

        return View(productos);
    }

    public async Task<IActionResult> Details(int? id)
    {
        if (id == null) return NotFound();

        var producto = await _context.Productos
            .FirstOrDefaultAsync(p => p.Id == id);

        if (producto == null) return NotFound();

        return View(producto);
    }

    public IActionResult Create()
    {
        ViewData["CategoriaId"] = new SelectList(
            _context.Categorias.Where(c => c.Activa),
            "Id",
            "Nombre");

        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Producto producto)
    {
        if (!ModelState.IsValid)
        {
            ViewData["CategoriaId"] = new SelectList(
                _context.Categorias.Where(c => c.Activa),
                "Id",
                "Nombre",
                producto.CategoriaId);

            return View(producto);
        }

        producto.FechaCreacion = DateTime.Now;
        _context.Add(producto);
        await _context.SaveChangesAsync();

        return RedirectToAction(nameof(Index));
    }

    public async Task<IActionResult> Edit(int? id)
    {
        if (id == null)
            return NotFound();

        var producto = await _context.Productos.FindAsync(id);

        if (producto == null)
            return NotFound();

        ViewData["CategoriaId"] = new SelectList(
            _context.Categorias.Where(c => c.Activa),
            "Id",
            "Nombre",
            producto.CategoriaId);

        return View(producto);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Producto producto)
    {
        if (id != producto.Id) return NotFound();

        if (!ModelState.IsValid)
        {
            ViewData["CategoriaId"] = new SelectList(
                _context.Categorias.Where(c => c.Activa),
                "Id",
                "Nombre",
                producto.CategoriaId);

            return View(producto);
        }

        try
        {
            _context.Update(producto);
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            bool existe = await _context.Productos.AnyAsync(p => p.Id == id);
            if (!existe) return NotFound();
            throw;
        }

        return RedirectToAction(nameof(Index));
    }

    public async Task<IActionResult> Delete(int? id)
    {
        if (id == null) return NotFound();

        var producto = await _context.Productos
            .FirstOrDefaultAsync(p => p.Id == id);

        if (producto == null) return NotFound();

        return View(producto);
    }

    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
        var producto = await _context.Productos.FindAsync(id);

        if (producto != null)
        {
            _context.Productos.Remove(producto);
            await _context.SaveChangesAsync();
        }

        return RedirectToAction(nameof(Index));
    }
}
