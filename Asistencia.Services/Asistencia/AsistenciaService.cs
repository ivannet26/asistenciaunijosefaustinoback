using Asistencia.Abstractions.IRepository;
using Asistencia.Abstractions.IService;
using Asistencia.DTO.Asistencia;
using Asistencia.DTO.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Asistencia.Services.Asistencia
{
    public class AsistenciaService:IAsistenciaService
    {
        private IAsistenciaRepository _asistenciaRepositorio;
        public AsistenciaService(IAsistenciaRepository asistenciaRepositorio)
        {
            this._asistenciaRepositorio = asistenciaRepositorio;
        }

        public async Task<ResultDTO<AsistenciaGeneralResponse>> TraeAsistenciaGeneral(string fechainicio, 
            string fechafin, string marcadores)
        {
            return await this._asistenciaRepositorio.TraeAsistenciaGeneral(fechainicio, fechafin, marcadores);
        }

        public async Task<ResultDTO<AsistenciaDetalleResponse>> TraeDetalle(string fechainicio, string fechafin, string codigoempleado)
        {
            return await this._asistenciaRepositorio.TraeDetalle(fechainicio, fechafin, codigoempleado);
        }

        public async Task<ResultDTO<PlanillaResponse>> TraePlanilla()
        {
            return await this._asistenciaRepositorio.TraePlanilla();
        }

        public async  Task<ResultDTO<AsistenciaResumidoResponse>> TraeResumen(string fechaInicio, 
            string fechaFin, string codigoPlanilla)
        {
            return await this._asistenciaRepositorio.TraeResumen(fechaInicio, fechaFin, codigoPlanilla);
        }

        public async Task<ResultDTO<DepartamentoResponse>> TraeDepartamento(string empresa)
        {
            return await this._asistenciaRepositorio.TraeDepartamento(empresa);
        }

        public async Task<ResultDTO<AsistenciaReporteDetResponse>> TraeReporte(string fechainicio, string fechafin)
        {
            //return await this.TraeReporte(fechainicio, fechafin);
            return await this._asistenciaRepositorio.TraeReporte(fechainicio, fechafin);
        }
    }
}
