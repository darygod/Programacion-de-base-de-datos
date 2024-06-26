SET SERVEROUTPUT ON

VAR B_RUT NUMBER;
EXEC :B_RUT := &RUT

DECLARE 
    --CREACION COLUMNAS--
    V_MES_ANNO              NUMBER(6);
    V_DV                    VARCHAR2(1);
    V_NOMBRE_EMP            VARCHAR2(60);
    V_NOMBRE_US             VARCHAR2(9);
    V_CLAVE_US              VARCHAR2(30);
    --CREACION DE USUARIOS--
    V_PNOMBRE               VARCHAR2(60);
    V_3PNOMBRE              VARCHAR2(3);
    V_LPNOMBRE              NUMBER(3);
    V_SULDO_BASE            NUMBER(10);
    V_ULD_SULEDO_BASE       NUMBER(1);
    V_FECHA_CONTRATO        EMPLEADO.FECHA_CONTRATO%TYPE;
    V_ANNOS_TRABAJANDO      NUMBER(3);
    --CREACION DE CONTRASEÑA--
    V_3RORUN                NUMBER(1);  
    V_FECHA_NACIMIENTO      EMPLEADO.FECHA_NAC%TYPE;
    V_FECHA_NACIMIENTO_AUM  NUMBER(5);
    V_SUEL_BASE_DIS         NUMBER(4);
    V_APATERNO              VARCHAR2(50); 
    V_ESTADO_CIVIL          NUMBER(2);
    V_LETRAS_APATERNO       VARCHAR2(2);
    V_ID_COMUNA             NUMBER(3);
    V_COMUNA                VARCHAR2(50);
    V_PLETRA_COMUNA         VARCHAR2(1);

BEGIN
    SELECT ID_COMUNA,
           ID_ESTADO_CIVIL,
           APPATERNO_EMP,
           FECHA_NAC,
           PNOMBRE_EMP,
           SUELDO_BASE,
           FECHA_CONTRATO,
           DVRUN_EMP,
           PNOMBRE_EMP ||' '||SNOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP
    INTO   V_ID_COMUNA,V_ESTADO_CIVIL,V_APATERNO,V_FECHA_NACIMIENTO,V_PNOMBRE,V_SULDO_BASE,V_FECHA_CONTRATO,V_DV,V_NOMBRE_EMP
    FROM   EMPLEADO    
    WHERE  NUMRUN_EMP= :B_RUT;  
    
   
    --CREAR NOMBRE DE USUARIO--
    V_3PNOMBRE:= SUBSTR(v_pnombre, 1, 3);
    V_LPNOMBRE:= LENGTH(v_pnombre);
    V_ULD_SULEDO_BASE:=SUBSTR(V_SULDO_BASE, -1);
    V_ANNOS_TRABAJANDO:=ROUND(MONTHS_BETWEEN(SYSDATE, V_FECHA_CONTRATO) / 12);
    V_NOMBRE_US:=V_3PNOMBRE||V_LPNOMBRE||'*'||V_ULD_SULEDO_BASE||V_DV||V_ANNOS_TRABAJANDO;
    
    --VARIACION SEGUN AÑOS EN LA EMPRESA
    if V_ANNOS_TRABAJANDO <10 then 
        V_NOMBRE_US:= V_NOMBRE_US||'x';
    end if;
    
    --CREACION DE CONTRASEÑA DEL USUARIO
    
    V_3RORUN:=SUBSTR(TO_CHAR(:B_RUT),3,1);
    V_FECHA_NACIMIENTO_AUM:= TO_NUMBER(SUBSTR(TO_CHAR(V_FECHA_NACIMIENTO, 'YYYY'), 1, 4)) + 2;
    V_SUEL_BASE_DIS:=TO_NUMBER(SUBSTR(V_SULDO_BASE,-1,-3))-1;
    --VARICION SEGUN ESTADO CIVIL--
    IF V_ESTADO_CIVIL = 10 OR V_ESTADO_CIVIL = 60 THEN
        V_LETRAS_APATERNO := SUBSTR(v_apaterno, 1, 2);
    ELSIF V_ESTADO_CIVIL = 20 OR V_ESTADO_CIVIL = 30 THEN
        V_LETRAS_APATERNO := SUBSTR(v_apaterno, 1, 1) || SUBSTR(v_apaterno, -1);
    ELSIF V_ESTADO_CIVIL = 40 THEN
        V_LETRAS_APATERNO := SUBSTR(v_apaterno, -3, 2);
    ELSE
        V_LETRAS_APATERNO := SUBSTR(v_apaterno, -2);
    END IF;

    
    V_MES_ANNO:= TO_CHAR(SYSDATE, 'MMYYYY');
    SELECT NOMBRE_COMUNA INTO V_COMUNA FROM COMUNA WHERE  ID_COMUNA= V_ID_COMUNA;
    
    V_PLETRA_COMUNA:= SUBSTR(V_COMUNA,1,1);
    
    
    V_CLAVE_US:= V_3RORUN||V_FECHA_NACIMIENTO_AUM||   V_SUEL_BASE_DIS   ||LOWER(V_LETRAS_APATERNO)|| V_MES_ANNO||V_PLETRA_COMUNA;
    
    DBMS_OUTPUT.PUT_LINE(V_CLAVE_US);
    
   
    
END;
