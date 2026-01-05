using Asistencia.Abstractions.IApplication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Asistencia.WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AsistenciaController : Controller
    {

        private IAsistenciaApplication _asistenciApplicacion;
        public AsistenciaController(IAsistenciaApplication asistenciApplicacion)
        {
            _asistenciApplicacion = asistenciApplicacion;
        }

        [HttpGet]
        [Route("SpListCalculoDetalle")]
        public async Task<ActionResult> SpTraeDetalle(string fechainicio, string fechafin, string codigoempleado)
        {
            try
            {
                var result = await this._asistenciApplicacion.TraeDetalle(fechainicio, fechafin, codigoempleado);
                return Ok(result);
            }
            catch (Exception ex) {
                return BadRequest(ex.Message);
            }
        }



        [HttpGet]
        [Route("SpListCalculoResumen")]
        public async Task<ActionResult> SpTraeResumen(string fechainicio, string fechafin, string codigoplanilla)
        {
            try
            {
                var result = await this._asistenciApplicacion.TraeResumen(fechainicio, fechafin, codigoplanilla);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet]
        [Route("SpListPlanilla")]
        public async Task<ActionResult> SpTraePlanilla()
        {
            try
            {
                var result = await this._asistenciApplicacion.TraePlanilla();
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

        [HttpGet]
        [Route("SpListAsistenciGeneral")]
        public async Task<ActionResult> SpTraeAsistenciaGeneral(string fechainicio, string fechafin, string marcadores="") 
        {
            try
            {
                var result = await this._asistenciApplicacion.TraeAsistenciaGeneral(fechainicio, fechafin, marcadores);
                return Ok(result);
            }
            catch (Exception ex) {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet]
        [Route("SpListaDepartamento")]
        public async Task<ActionResult> SpTraeDepartamento(string empresa)
        {
            try {
                var result = await this._asistenciApplicacion.TraeDepartamento(empresa);
                return Ok(result);
            }catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet]
        [Route("SpListaReporte")]
        public async Task<ActionResult> SpTraeReporte(string fechainicio, string fechafin)
        {

            try {
                var result = await this._asistenciApplicacion.TraeReporte(fechainicio, fechafin);
                return Ok(result);
            }catch( Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
