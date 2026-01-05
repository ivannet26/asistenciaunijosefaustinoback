using Asistencia.DTO.Asistencia;
using Asistencia.DTO.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Asistencia.Abstractions.IService
{
    public interface IAsistenciaService
    {
        public Task<ResultDTO<AsistenciaResumidoResponse>> TraeResumen(string fechaInicio,
        string fechaFin, string codigoPlanilla);
        public Task<ResultDTO<AsistenciaDetalleResponse>> TraeDetalle(string fechainicio, string fechafin, string codigoempleado);

        public Task<ResultDTO<PlanillaResponse>> TraePlanilla();

        public Task<ResultDTO<AsistenciaGeneralResponse>> TraeAsistenciaGeneral(string fechainicio, 
            string fechafin, string marcadores);


        public Task<ResultDTO<DepartamentoResponse>> TraeDepartamento(string empresa);

        public Task<ResultDTO<AsistenciaReporteDetResponse>> TraeReporte(string fechainicio, string fechafin);
    }
}
