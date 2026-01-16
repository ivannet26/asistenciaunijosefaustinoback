using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Asistencia.DTO.Asistencia
{
    public class ReporteBasicoResponse
    {
        /*
         CodigoEmpleado	NombreEmpleado	unidadDepartamento	FechaFormateada	Dia	NombreMarcador	Ingreso	Salida	TiempoTotal
15609993	LIDIA SOLEDAD DE LA CRUZ LA ROSA	SECRETARIA GENERAL	03/11/2025	lunes	SENSEFACE 7A	07:48	07:48	00:00
         */
        public string codigoEmpleado { get; set; }
        public string nombreEmpleado { get; set; }
        public string unidadDepartamento { get; set; }
        public string fechaFormateada { get; set; }
        public string dia { get; set; }
        public string nombreMarcador { get; set; }
        public string ingreso { get; set; }
        public string salida { get; set; }
        public string tiempoTotal { get; set; }

        public string tiempoFormateado { get; set; }
    }
}
