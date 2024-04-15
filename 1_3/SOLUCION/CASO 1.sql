--- CASO 1 ---
SET SERVEROUT ON

--var b_run NUMBER(8)
--EXEC :b_run := &run


DECLARE
    --VARIABLES EJERCICIO
    V_RUN               VARCHAR2(13):=&RUT;
    V_NRO_CLI                       NUMBER (4);
    V_RUN_CLI                       VARCHAR2 (20);
    V_NOM_CLI                       VARCHAR2(100);
    V_TIP_CLI                       VARCHAR2(100);
    V_MONTO_SOL                     NUMBER(10);
    V_MONTO_PESOS_TODOMUMA_TOTAL    NUMBER (10);
    --PESOS TODO SUMA
    V_FACTOR                        NUMBER(10);
    V_PESOS_TODO_SUMA               NUMBER(10);
    
BEGIN

    SELECT
        cli.NRO_CLIENTE,
        TO_CHAR(cli.NUMRUN,'09G999G999')||'-'||cli.DVRUN,
        cli.PNOMBRE||' '||cli.SNOMBRE||' '||cli.APPATERNO||' '||cli.APMATERNO,
        ti.NOMBRE_TIPO_CLIENTE,
        SUM(cc.MONTO_SOLICITADO)
   INTO 
         V_NRO_CLI,V_RUN_CLI,V_NOM_CLI,V_TIP_CLI,V_MONTO_SOL
    FROM CLIENTE cli
    JOIN CREDITO_CLIENTE cc ON cli.NRO_CLIENTE=cc.NRO_CLIENTE
    JOIN TIPO_CLIENTE ti on cli.COD_TIPO_CLIENTE=ti.COD_TIPO_CLIENTE
    WHERE EXTRACT(YEAR FROM cc.FECHA_SOLIC_CRED )=EXTRACT(YEAR FROM SYSDATE)-1
         AND cli.NUMRUN = V_RUN

         
    group by cli.NRO_CLIENTE,TO_CHAR(cli.NUMRUN,'09G999G999')||'-'||cli.DVRUN,
              cli.PNOMBRE||' '||cli.SNOMBRE||' '||cli.APPATERNO||' '||cli.APMATERNO, ti.NOMBRE_TIPO_CLIENTE;
              
    V_FACTOR:= (V_MONTO_SOL/100000);
    
IF V_TIP_CLI = 'Trabajadores independientes' THEN
        CASE 
            WHEN V_MONTO_SOL < 1000000 THEN V_PESOS_TODO_SUMA:= 100;
            WHEN V_MONTO_SOL >= 1000001 AND V_MONTO_SOL < 3000000 THEN V_PESOS_TODO_SUMA := 300;
            ELSE V_PESOS_TODO_SUMA:= 550;
            END CASE;
    END IF;
            
    V_MONTO_PESOS_TODOMUMA_TOTAL:= ROUND(V_FACTOR*V_PESOS_TODO_SUMA)+(V_FACTOR*1200);
    DBMS_OUTPUT.PUT_LINE('Factor: ' || v_factor);
    DBMS_OUTPUT.PUT_LINE('Total pesos adicionales: ' || V_PESOS_TODO_SUMA);
    DBMS_OUTPUT.PUT_LINE('Total pesos: ' || V_MONTO_PESOS_TODOMUMA_TOTAL);
    INSERT INTO cliente_todosuma VALUES(V_NRO_CLI,V_RUN_CLI ,V_NOM_CLI,V_TIP_CLI,V_MONTO_SOL,V_MONTO_PESOS_TODOMUMA_TOTAL);
   
    
END;


SELECT
    nro_cliente,
    run_cliente,
    nombre_cliente,
    tipo_cliente,
    monto_solic_creditos,
    monto_pesos_todosuma
FROM
    cliente_todosuma;