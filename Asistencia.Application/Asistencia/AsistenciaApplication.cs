using Asistencia.Abstractions.IApplication;
using Asistencia.Abstractions.IService;
using Asistencia.DTO.Asistencia;
using Asistencia.DTO.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Asistencia.Application.Asistencia
{
    
    public class AsistenciaApplication:IAsistenciaApplication
    {
        private IAsistenciaService _asistenciaServicio;
        public AsistenciaApplication(IAsistenciaService asistenciaServicio)
        {
            _asistenciaServicio = asistenciaServicio;
        }

        public async Task<ResultDTO<AsistenciaGeneralResponse>> TraeAsistenciaGeneral(string fechainicio, 
            string fechafin, string marcadores)
        {
          return await this._asistenciaServicio.TraeAsistenciaGeneral(fechainicio, fechafin, marcadores);
        }

        public async Task<ResultDTO<AsistenciaDetalleResponse>> TraeDetalle(string fechainicio, string fechafin, string codigoempleado)
        {
            return await this._asistenciaServicio.TraeDetalle(fechainicio, fechafin, codigoempleado);
        }

        public async Task<ResultDTO<PlanillaResponse>> TraePlanilla()
        {
            return await this._asistenciaServicio.TraePlanilla();
        }

        public async Task<ResultDTO<AsistenciaResumidoResponse>> TraeResumen(string fechaInicio, string fechaFin, string codigoPlanilla)
        {
            return await this._asistenciaServicio.TraeResumen(fechaInicio, fechaFin, codigoPlanilla);
        }

        public async Task<ResultDTO<DepartamentoResponse>> TraeDepartamento(string empresa)
        {
            return await this._asistenciaServicio.TraeDepartamento(empresa);
        }

        public async Task<ResultDTO<AsistenciaReporteDetResponse>> TraeReporte(string fechainicio, string fechafin)
        {
            //return await this.TraeReporte(fechainicio, fechafin);
            return await this._asistenciaServicio.TraeReporte(fechainicio, fechafin);
        }
    }
}
