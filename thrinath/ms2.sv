module memory_stage2(
    input logic clk,
    input logic reset,
    input logic  [15:0] MS2_IN[0:15][0:1],
    input logic MS2_IN_VALID,

    output logic [15:0] MS2_OUT[0:15][0:1],
    output logic MS2_OUT_VALID
);


///////////////////////////////////////////////////////  MEMORY ////////////////////////////////////////////////////////////

    logic [15:0] RAM[0:15][0:15][0:1];
    logic [3:0] Address[0:15];
    //logic we[0:15];
    logic [15:0] Din[0:15][0:1];
    logic [15:0] Dout[0:15][0:1];


    always_ff@(posedge clk) begin
        for(int i=0;i<16;i++) begin
            RAM[i][Address[i]][0] <= Din[i][0];
            RAM[i][Address[i]][1] <= Din[i][1];
            Dout[i][0] <= RAM[i][Address[i]][0];
            Dout[i][1] <= RAM[i][Address[i]][1];
        end
    end


///////////////////////////////////////////////////////  LCS & RCS ////////////////////////////////////////////////////////////

    logic [3:0] RCS[0:15];
    logic [3:0] LCS[0:15];
    logic [3:0] Global_Counter;

    logic lcs_shift;
    /*
    always@(posedge clk)begin
        if(reset) lcs_shift <=0;
        else if(Shift_Counter ==15) lcs_shift <=1;
        else lcs_shift <=0;    
    end
            */

    always@(posedge clk)begin
        if(reset)begin
            for(int i=0;i<16;i++) begin
                RCS[i] <=i;
                LCS[i] <=i;
            end
            Global_Counter <=0;
        end
        else if(MS2_IN_VALID) begin
            RCS[0] <= RCS[15];
            for(int i=1;i<16;i++) RCS[i] <=RCS[i-1]; 

            LCS[15] <= LCS[0];
            for(int i=0;i<15;i++) LCS[i] <=LCS[i+1];
            
            Global_Counter <= Global_Counter +1;
        end
    end


////////////////////////////////////////////////////////// ADDRESS GENERATION //////////////////////////////////////////////////


    logic set;
    always@(posedge clk) begin
        if(reset) set<=0;
        else if(Global_Counter==15) set <=!set;
    end

    

    always_comb begin
        for(int i=0;i<16;i++) begin
            Din[i][0] = MS2_IN[RCS[i]][0];
            Din[i][1] = MS2_IN[RCS[i]][1];
        end
    end


    

    logic [7:0] Address_ROM[0:15];
    always_comb begin
        for(int i=0;i<16;i++) begin
            Address_ROM[i] = RCS[i];
        end
    end

    always_comb begin
        if(set==0) begin
            for(int i=0;i<16;i++) begin
                Address[i] = Global_Counter;
            end
        end
        else begin
            for(int i=0;i<16;i++) begin
                Address[i] = Address_ROM[i];
            end
        end
    end

/////////////////////////////////////////////////////////  OUTPUT /////////////////////////////////////////////////////////    

    always_comb begin
        for(int i=0;i<16;i++) begin
            MS2_OUT[i][0] = Dout[LCS[i]][0];
            MS2_OUT[i][1] = Dout[LCS[i]][1];
        end
    end

///////////////////// VALID /////////////////////////
    always@(posedge clk) begin
        if(reset) MS2_OUT_VALID <=0;
        else if(set==1) MS2_OUT_VALID <=1;
    end
    


endmodule
