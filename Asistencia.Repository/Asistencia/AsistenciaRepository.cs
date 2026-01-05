using Asistencia.Abstractions.IRepository;
using Asistencia.DTO.Asistencia;
using Asistencia.DTO.Common;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Asistencia.Repository.Asistencia
{
    public class AsistenciaRepository : IAsistenciaRepository
    {
        private string _connectionString = "";
        public AsistenciaRepository(IConfiguration configuracion)
        {
            this._connectionString = configuracion.GetConnectionString("conexion");
        }

        public async Task<ResultDTO<AsistenciaGeneralResponse>> TraeAsistenciaGeneral(string fechainicio, 
            string fechafin, string marcadores ="")
        {
            ResultDTO<AsistenciaGeneralResponse> res = new ResultDTO<AsistenciaGeneralResponse>();
            List<AsistenciaGeneralResponse> lista = new List<AsistenciaGeneralResponse>();
            try
            {
                SqlConnection cn = new SqlConnection(this._connectionString);
                DynamicParameters parametros = new DynamicParameters();
                parametros.Add("@fechainicio", fechainicio);
                parametros.Add("@fechafin", fechafin);
                parametros.Add("@marcadores", marcadores);
                lista = (List<AsistenciaGeneralResponse>)await cn.QueryAsync<AsistenciaGeneralResponse>("Spu_Int_Traer_AsistenciaGeneral",
                    parametros, commandType: CommandType.StoredProcedure);
                res.IsSuccess = lista.Count > 0 ? true : false;
                res.Message = lista.Count > 0 ? "Informacion encotnrada" : "No se encuentra informacion";
                res.Data = lista.ToList();
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.MessageException = ex.Message;
            }
            return res;
        }

        public async Task<ResultDTO<AsistenciaDetalleResponse>> TraeDetalle(string fechainicio, string fechafin,string codigoempleado)
        {
            ResultDTO<AsistenciaDetalleResponse> res = new ResultDTO<AsistenciaDetalleResponse>();
            List<AsistenciaDetalleResponse> lista = new List<AsistenciaDetalleResponse>();
            try
            {
                SqlConnection cn = new SqlConnection(_connectionString);
                DynamicParameters parametros = new DynamicParameters();
                parametros.Add("@fechaInicio", fechainicio);
                parametros.Add("@fechaFin", fechafin);               
                parametros.Add("@codigoempleado", codigoempleado);
                
                lista = (List<AsistenciaDetalleResponse>)await cn.QueryAsync<AsistenciaDetalleResponse>("Spu_Int_Trae_CalculoAsistenciaDetalle",
                    parametros, commandType : CommandType.StoredProcedure);
                res.IsSuccess = lista.Count > 0 ? true : false;
                res.Message = lista.Count > 0 ? "Informacion encotnrada" : "No se encuentra informacion";
                res.Data  = lista.ToList();

                
            }
            catch (Exception ex) {
                res.IsSuccess = false;
                res.MessageException = ex.Message;
            }
            return res;
        }

        public async Task<ResultDTO<PlanillaResponse>> TraePlanilla()
        {
            ResultDTO<PlanillaResponse> res = new ResultDTO<PlanillaResponse>();
            List<PlanillaResponse> lista = new List<PlanillaResponse>();
            try
            {
                SqlConnection cn = new SqlConnection(this._connectionString);
                DynamicParameters parametros = new DynamicParameters();
                //parametros.Add("@fechaInicio", fechaInicio);
                //parametros.Add("@fechaFin", fechaFin);
                //parametros.Add("@codigoPlanilla", codigoPlanilla);

                lista = (List<PlanillaResponse>)await cn.QueryAsync<PlanillaResponse>("Spu_Int_Trae_Planilla",
                    parametros, commandType: CommandType.StoredProcedure);
                res.IsSuccess = lista.Count > 0 ? true : false;
                res.Message = lista.Count > 0 ? "Informacion encotnrada" : "No se encuentra informacion";
                res.Data = lista.ToList();
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.MessageException = ex.Message;
            }
            return res;
        }

        public async Task<ResultDTO<AsistenciaResumidoResponse>> TraeResumen(string fechaInicio, string fechaFin, string codigoPlanilla)
        {
            ResultDTO<AsistenciaResumidoResponse> res = new ResultDTO<AsistenciaResumidoResponse>();
            List<AsistenciaResumidoResponse> lista = new List<AsistenciaResumidoResponse>();
            try
            {
                SqlConnection cn = new SqlConnection(_connectionString);
                DynamicParameters parametros = new DynamicParameters();
                parametros.Add("@fechaInicio", fechaInicio);
                parametros.Add("@fechaFin", fechaFin);
                parametros.Add("@codigoPlanilla", codigoPlanilla);
                
                lista = (List<AsistenciaResumidoResponse>)await cn.QueryAsync<AsistenciaResumidoResponse>("Spu_Int_Trae_CalculoAsistenciaResumido",
                    parametros, commandType: CommandType.StoredProcedure);
                res.IsSuccess = lista.Count > 0 ? true : false;
                res.Message = lista.Count > 0 ? "Informacion encotnrada" : "No se encuentra informacion";
                res.Data = lista.ToList();
            }
            catch (Exception ex)
            {
                res.IsSuccess = false;
                res.MessageException = ex.Message;
            }
            return res;
        }

        public async  Task<ResultDTO<DepartamentoResponse>> TraeDepartamento(string empresa)
        {
            ResultDTO<DepartamentoResponse> res = new ResultDTO<DepartamentoResponse>();
            List<DepartamentoResponse> lista = new List<DepartamentoResponse>();
            try 
            {
                SqlConnection cn = new SqlConnection(this._connectionString);
                DynamicParameters parametros = new DynamicParameters();
                parametros.Add("@empresa", empresa);
                lista = (List<DepartamentoResponse>)await cn.QueryAsync<DepartamentoResponse>("Spu_Int_Trae_Departamento", parametros, commandType: CommandType.StoredProcedure);
                res.IsSuccess = lista.Count > 0 ? true : false;
                res.Message = lista.Count > 0 ? "informacion encontrada" : "No se encontro informacion";
                res.Data = lista.ToList();

            }catch( Exception ex)
            {
                res.IsSuccess = false;

                res.MessageException = ex.Message;
            }
            return res;
        }

        public async Task<ResultDTO<AsistenciaReporteDetResponse>> TraeReporte(string fechainicio, string fechafin)
        {
            ResultDTO<AsistenciaReporteDetResponse> res = new ResultDTO<AsistenciaReporteDetResponse>();
            List<AsistenciaReporteDetResponse> lista = new List<AsistenciaReporteDetResponse>();
            try
            {
                SqlConnection cn = new SqlConnection(this._connectionString);
                DynamicParameters parametros = new DynamicParameters();
                parametros.Add("@fechaInicio", fechainicio);
                parametros.Add("@fechafin", fechafin);
                lista = (List<AsistenciaReporteDetResponse>)await cn.QueryAsync<AsistenciaReporteDetResponse>("Spu_Int_Trae_ReporteAsistenciaDetallado", 
                    parametros, commandType: CommandType.StoredProcedure);
                res.IsSuccess = lista.Count > 0 ? true : false;
                res.Message = lista.Count > 0 ? "Informacion encontrada" : "No se encontro informacion";
                res.Data = lista.ToList();
            }
            catch (Exception ex) {
                res.IsSuccess = false;
                res.MessageException = ex.Message;
            }
            return res;
        }
    }
}
