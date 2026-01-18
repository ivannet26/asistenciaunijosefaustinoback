use InterfazBiotime
go
--select * from  sys.objects where type = 'P' order by modify_date desc
--exec [Spu_Int_Trae_ReporteAsistenciaDetallado] '17/01/2026', '17/01/2026'  
  
--select *   
--FROM ZKBIOTIME.dbo.iclock_transaction marcaciones    
--    WHERE marcaciones.punch_time >= CONVERT(DATETIME, '01/01/2026', 103)    
-- and marcaciones.punch_time <= DATEADD(day,1 ,CONVERT(datetime, '17/01/2026',103))   
  
alter PROCEDURE [dbo].[Spu_Int_Trae_ReporteAsistenciaDetallado]    
@fechaInicio AS VARCHAR(10),    
@fechafin AS VARCHAR(10)    
AS    
BEGIN    
--declare @fechaInicio AS VARCHAR(10)  
--declare @fechafin AS VARCHAR(10)    
--set @fechaInicio  = '17/01/2026'  
--set @fechafin ='17/01/2026'  
DECLARE @cols NVARCHAR(MAX);    
    DECLARE @sql NVARCHAR(MAX);    
    DECLARE @MaxMarcaNum INT;    
    DECLARE @Counter INT = 1;    
    
    -- Paso 0: Preparación de la tabla temporal de marcaciones    
    IF OBJECT_ID('tempdb..#tblMarcaciones') IS NOT NULL    
    BEGIN    
        DROP TABLE #tblMarcaciones;    
    END    
    
    SELECT DISTINCT   
        emp_id,    
        emp_code COLLATE Modern_Spanish_CI_AS AS emp_code,     
        CONVERT(VARCHAR(10), marcaciones.punch_time, 103) COLLATE Modern_Spanish_CI_AS AS fecha,     
        CONVERT(VARCHAR(5), marcaciones.punch_time, 108) COLLATE Modern_Spanish_CI_AS AS hora    
    INTO #tblMarcaciones    
    FROM ZKBIOTIME.dbo.iclock_transaction marcaciones    
    WHERE marcaciones.punch_time >= CONVERT(DATETIME, @fechaInicio, 103)    
 and marcaciones.punch_time <= DATEADD(day,1 ,CONVERT(datetime, @fechafin,103))    
     -- AND marcaciones.punch_time <= CONVERT(DATETIME, @fechafin + ' 23:59:59', 103)    
    ORDER BY emp_code, fecha, hora;    
  -- DATEADD(day,1 ,CONVERT(datetime, @fechafin,103))    
    IF OBJECT_ID('tempdb..#tblMarcacionesPivot') IS NOT NULL    
    BEGIN    
        DROP TABLE #tblMarcacionesPivot;    
    END;    
    
    WITH MarcacionesConIndice AS (    
        SELECT     
            emp_id,    
            emp_code,     
            fecha,     
            hora,    
            ROW_NUMBER() OVER (  
                PARTITION BY (emp_code + fecha)   
                ORDER BY hora  
            ) AS MarcaNum     
        FROM #tblMarcaciones    
    )    
    SELECT   
        emp_id, emp_code, fecha,    
        [1] AS ingreso1, [2] AS salida1, [3] AS ingreso2, [4] AS Salida2, [5] AS Ingreso3,    
        [6] AS Salida3, [7] AS Ingreso4, [8] AS Salida4, [9] AS Ingreso5, [10] AS Salida5,    
        [11] AS Ingreso6, [12] AS Salida6, [13] AS Ingreso7, [14] AS Salida7, [15] AS Ingreso8,    
        [16] AS Salida8, [17] AS Ingreso9, [18] AS Salida9, [19] AS Ingreso10, [20] AS Salida10    
    INTO #tblMarcacionesPivot    
    FROM (SELECT emp_id, emp_code, fecha, hora, MarcaNum FROM MarcacionesConIndice) AS src    
    PIVOT(MAX(hora) FOR MarcaNum IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20])) AS pvt;    
    
  
  
    IF OBJECT_ID('tempdb..#tblAsistencia') IS NOT NULL    
    BEGIN    
        DROP TABLE #tblAsistencia;    
    END;    
    
    SELECT * INTO #tblAsistencia FROM (    
          
 SELECT   
    emp_code, tbl.fecha,   
    DATENAME(WEEKDAY, TRY_CONVERT(DATE, tbl.fecha, 103)) COLLATE Modern_Spanish_CI_AS AS diaNombre,              
    Ingreso1, Salida1, Ingreso2, Salida2, Ingreso3, Salida3, Ingreso4, Salida4, Ingreso5, Salida5,    
    Ingreso6, Salida6, Ingreso7, Salida7, Ingreso8, Salida8, Ingreso9, Salida9, Ingreso10, Salida10,    
      
    -- Cálculo ultra-seguro usando TRY_CONVERT a TIME  
    CONVERT(VARCHAR(5), DATEADD(MINUTE,   
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso1), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida1,'') IN ('', '00:00') THEN Ingreso1 ELSE Salida1 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso2), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida2,'') IN ('', '00:00') THEN Ingreso2 ELSE Salida2 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso3), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida3,'') IN ('', '00:00') THEN Ingreso3 ELSE Salida3 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso4), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida4,'') IN ('', '00:00') THEN Ingreso4 ELSE Salida4 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso5), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida5,'') IN ('', '00:00') THEN Ingreso5 ELSE Salida5 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso6), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida6,'') IN ('', '00:00') THEN Ingreso6 ELSE Salida6 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso7), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida7,'') IN ('', '00:00') THEN Ingreso7 ELSE Salida7 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso8), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida8,'') IN ('', '00:00') THEN Ingreso8 ELSE Salida8 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso9), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida9,'') IN ('', '00:00') THEN Ingreso9 ELSE Salida9 END)), 0) +  
        ISNULL(DATEDIFF(MINUTE, TRY_CONVERT(TIME, Ingreso10), TRY_CONVERT(TIME, CASE WHEN ISNULL(Salida10,'') IN ('', '00:00') THEN Ingreso10 ELSE Salida10 END)), 0)  
    , 0), 108) AS HFinalDia,    
  
    '' COLLATE Modern_Spanish_CI_AS AS HTotalSemana,    
    '' COLLATE Modern_Spanish_CI_AS AS Observa,    
    '' COLLATE Modern_Spanish_CI_AS AS Obs_final,    
    '' COLLATE Modern_Spanish_CI_AS AS descuento    
    
  
FROM #tblMarcacionesPivot tbl  
        UNION ALL    
    
        -- Permisos    
        SELECT   
            vpp.emp_code COLLATE Modern_Spanish_CI_AS,   
            vpp.fecha COLLATE Modern_Spanish_CI_AS,   
            DATENAME(WEEKDAY, vpp.fecha) COLLATE Modern_Spanish_CI_AS,    
            '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',    
            '00:00' COLLATE Modern_Spanish_CI_AS,    
            '00:00' COLLATE Modern_Spanish_CI_AS,   
            vpp.NombreTipoPermiso COLLATE Modern_Spanish_CI_AS,    
            vpp.apply_reason COLLATE Modern_Spanish_CI_AS,    
            '' COLLATE Modern_Spanish_CI_AS    
        FROM ZKBIOTIME.dbo.VerPermisosDePersonal vpp    
        WHERE [start_time] >= CONVERT(DATETIME, @fechaInicio, 103)    
  AND [end_time] <= DATEADD(day,1 ,CONVERT(datetime, @fechafin,103))    
          --AND [end_time] <= CONVERT(DATETIME, @fechafin + ' 23:59:59', 103)    
    -- DATEADD(day,1 ,CONVERT(datetime, @fechafin,103))    
    ) tblConsolidado;    
    
    -- Feriados    
    IF OBJECT_ID('tempdb..#tblFeriados') IS NOT NULL    
    BEGIN    
        DROP TABLE #tblFeriados;    
    END;    
    
    WITH listapersonal AS (    
        SELECT DISTINCT emp_code FROM #tblAsistencia    
    )    
    SELECT   
        personal.emp_code,   
        CONVERT(VARCHAR(10), [start_date], 103) COLLATE Modern_Spanish_CI_AS AS fecha,       
        DATENAME(WEEKDAY, [start_date]) COLLATE Modern_Spanish_CI_AS AS diaNombre,       
        '' COLLATE Modern_Spanish_CI_AS AS Ingreso1, '' COLLATE Modern_Spanish_CI_AS AS Salida1,    
        '' COLLATE Modern_Spanish_CI_AS AS Ingreso2, '' COLLATE Modern_Spanish_CI_AS AS Salida2,       
        '' COLLATE Modern_Spanish_CI_AS AS Ingresa3, '' COLLATE Modern_Spanish_CI_AS AS Salida3,       
        '' COLLATE Modern_Spanish_CI_AS AS Ingresa4, '' COLLATE Modern_Spanish_CI_AS AS Salida4,       
        '' COLLATE Modern_Spanish_CI_AS AS Ingreso5, '' COLLATE Modern_Spanish_CI_AS AS Salida5,      
        '' COLLATE Modern_Spanish_CI_AS AS Ingreso6, '' COLLATE Modern_Spanish_CI_AS AS Salida6,      
        '' COLLATE Modern_Spanish_CI_AS AS Ingreso7, '' COLLATE Modern_Spanish_CI_AS AS Salida7,      
        '' COLLATE Modern_Spanish_CI_AS AS Ingreso8, '' COLLATE Modern_Spanish_CI_AS AS Salida8,      
        '' COLLATE Modern_Spanish_CI_AS AS Ingreso9, '' COLLATE Modern_Spanish_CI_AS AS Salida9,      
        '' COLLATE Modern_Spanish_CI_AS AS Ingreso10, '' COLLATE Modern_Spanish_CI_AS AS Salida10,       
        '00:00' COLLATE Modern_Spanish_CI_AS AS HFinalDia,    
        '00:00' COLLATE Modern_Spanish_CI_AS AS HTotalSemana,       
        'JUSTIFICA' COLLATE Modern_Spanish_CI_AS AS Observa,       
        alias COLLATE Modern_Spanish_CI_AS AS Obs_Final,   
        '' COLLATE Modern_Spanish_CI_AS AS descuento    
    INTO #tblFeriados    
    FROM ZKBIOTIME.dbo.att_holiday feriados   
    CROSS JOIN listapersonal personal    
    WHERE [start_date] <= CONVERT(DATETIME, @fechaInicio, 103)       
  AND end_date >= DATEADD(day,1 ,CONVERT(datetime, @fechaInicio,103))    
     -- AND end_date >= CONVERT(DATETIME, @fechaInicio , 103);    
  --DATEADD(day,1 ,CONVERT(datetime, @fechafin,103))    
    INSERT INTO #tblAsistencia    
    SELECT feriados.* FROM #tblFeriados feriados   
    LEFT JOIN #tblAsistencia asistencia ON feriados.emp_code = asistencia.emp_code AND feriados.fecha = asistencia.fecha    
    WHERE asistencia.emp_code IS NULL;    
    
    UPDATE asistencia    
    SET asistencia.Obs_final = feriados.Obs_Final    
    FROM #tblAsistencia asistencia   
    INNER JOIN #tblFeriados feriados ON feriados.emp_code = asistencia.emp_code AND feriados.fecha = asistencia.fecha;    
    --select * from #tblAsistencia
    IF OBJECT_ID('tempdb..#tblReporte') IS NOT NULL    
    BEGIN    
        DROP TABLE #tblReporte;    
    END;    
    
    WITH diasAsistencias AS (  
        SELECT time_interval_id, COUNT(time_interval_id) AS cantidaddias    
        FROM ZKBIOTIME.dbo.att_shiftdetail    
        GROUP BY time_interval_id   
    )    
    SELECT    
        asistencia.emp_code AS 'codigo',     
        (emp.first_name + ' ' + emp.last_name) COLLATE Modern_Spanish_CI_AS AS 'nombre',   
        fecha, ingreso1, Salida1, Ingreso2, Salida2, Ingreso3, Salida3, Ingreso4, Salida4, Ingreso5, salida5,    
        Ingreso6, salida6, ingreso7, salida7, Ingreso8, salida8, Ingreso9, salida9, Ingreso10, salida10,    
        HFinalDia, HTotalSemana, diaNombre, Observa, Obs_final,     
        0 AS 'descuento', '' COLLATE Modern_Spanish_CI_AS AS 'total',     
        horario.alias COLLATE Modern_Spanish_CI_AS AS 'turno',     
        cargo.position_name COLLATE Modern_Spanish_CI_AS AS 'cargo',    
        departamento.dept_name COLLATE Modern_Spanish_CI_AS AS 'unidad',     
        turnodia.id AS 'idHorario',    
        (CASE WHEN turnodia.use_mode = 1 THEN 'S' ELSE 'N' END) COLLATE Modern_Spanish_CI_AS AS HorarioFlexible,    
        horariodiario.cantidaddias,    
        turnodia.work_time_duration,    
        '00:00' COLLATE Modern_Spanish_CI_AS AS 'hr_falta',    
        '' COLLATE Modern_Spanish_CI_AS AS cpu    
    INTO #tblReporte    
    FROM #tblAsistencia asistencia    
    INNER JOIN ZKBIOTIME.dbo.personnel_employee emp ON emp.emp_code COLLATE Modern_Spanish_CI_AS = asistencia.emp_code    
    INNER JOIN ZKBIOTIME.dbo.personnel_position cargo ON cargo.id = emp.position_id    
    INNER JOIN ZKBIOTIME.dbo.personnel_department departamento ON departamento.id = emp.department_id    
    left JOIN ZKBIOTIME.dbo.att_attschedule turno ON turno.employee_id = emp.id    
    left JOIN ZKBIOTIME.dbo.att_attshift horario ON horario.id = turno.shift_id    
    left JOIN diasAsistencias horariodiario ON horariodiario.time_interval_id = turno.shift_id    
    left JOIN ZKBIOTIME.dbo.att_timeinterval turnodia ON turnodia.id = horariodiario.time_interval_id    
    ORDER BY emp.emp_code ASC, CONVERT(DATETIME, fecha, 103) ASC;  
	--select *  FROM #tblAsistencia asistencia    
 --   INNER JOIN ZKBIOTIME.dbo.personnel_employee emp ON emp.emp_code COLLATE Modern_Spanish_CI_AS = asistencia.emp_code    
 --   INNER JOIN ZKBIOTIME.dbo.personnel_position cargo ON cargo.id = emp.position_id    
 --   INNER JOIN ZKBIOTIME.dbo.personnel_department departamento ON departamento.id = emp.department_id    
 --   left JOIN ZKBIOTIME.dbo.att_attschedule turno ON turno.employee_id = emp.id    
 --   left JOIN ZKBIOTIME.dbo.att_attshift horario ON horario.id = turno.shift_id    
 --   left JOIN diasAsistencias horariodiario ON horariodiario.time_interval_id = turno.shift_id    
 --   INNER JOIN ZKBIOTIME.dbo.att_timeinterval turnodia ON turnodia.id = horariodiario.time_interval_id    
 --   ORDER BY emp.emp_code ASC, CONVERT(DATETIME, fecha, 103) ASC;    
    --select * from #tblReporte
    -- Actualizaciones finales de tiempo semanal y faltas  

	--select * from #tblReporte
    WITH vistaTotalSemanal AS (  
        SELECT codigo, DATEPART(WK, CAST(fecha AS DATETIME)) AS NumeroSemana,     
        SUM(DATEDIFF(SECOND, '00:00', HFinalDia)) AS totalTiempoSemanal    
        FROM #tblReporte    
        GROUP BY codigo, DATEPART(WK, CAST(fecha AS DATETIME))    
    )    
    UPDATE reporte    
    SET reporte.HTotalSemana = dbo.formateatiempo(vista.totalTiempoSemanal, 's')    
    FROM vistaTotalSemanal vista    
    INNER JOIN #tblReporte reporte 
	ON vista.codigo = reporte.codigo 
	AND vista.NumeroSemana = DATEPART(WK, CAST(reporte.fecha AS DATETIME))    
    WHERE reporte.diaNombre = 'viernes' AND HorarioFlexible = 'S';    
  
    UPDATE #tblReporte SET HTotalSemana = '' WHERE diaNombre <> 'viernes';    
    
    UPDATE #tblReporte   
    SET hr_falta = ISNULL(dbo.FormateaTiempo(work_time_duration - dbo.obtenerTiempoMedida(HFinalDia, 'M'), 'M'), '00:00')    
    WHERE HorarioFlexible = 'N';    
    
    UPDATE #tblReporte SET hr_falta = '00:00' 
	WHERE HorarioFlexible = 'S' AND (HTotalSemana = '00:00' OR ISNULL(HTotalSemana,'') = '');    
    
    UPDATE #tblReporte    
    SET hr_falta = dbo.FormateaTiempo((work_time_duration * cantidaddias) - dbo.obtenerTiempoMedida(HTotalSemana, 'M'), 'M')    
    WHERE HorarioFlexible = 'S' AND (ISNULL(HTotalSemana,'') <> '');    
    
    UPDATE #tblReporte SET hr_falta = '00:00' WHERE ISNULL(Observa,'') <> '' AND HFinalDia = '00:00';    
    
    -- Resultado Final  
    SELECT   
        codigo, nombre, fecha, ingreso1, Salida1, ingreso2, Salida2, Ingreso3, Salida3, Ingreso4, salida4,    
        Ingreso5, Salida5, Ingreso6, Salida6, Ingreso7, Salida7, Ingreso8, Salida8, Ingreso9, salida9,    
        Ingreso10, Salida10, HFinalDia, Observa, diaNombre, Obs_final, descuento, HTotalSemana,    
        turno, cargo, unidad, hr_falta, cpu    
    FROM #tblReporte    
    ORDER BY codigo, CONVERT(DATETIME, fecha, 103) ASC;    
    
END;