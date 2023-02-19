module ControlUnit(
  input  [31:0] io_instr,
  input         io_eq,
  input         io_ge,
  input         io_geu,
  input         io_cpu_wait,
  input         io_cpu_ready,
  output [2:0]  io_format,
  output [3:0]  io_ALUCtrl,
  output        io_regWrite,
  output        io_memWrite,
  output        io_memRead,
  output        io_rs2Imm,
  output        io_aluMem,
  output        io_pcAluMem,
  output        io_pcImm,
  output        io_immBranch,
  output        io_aluBranch,
  output        io_stall,
  output [1:0]  io_storeType
);
  wire [6:0] opcode = io_instr[6:0]; // @[ControlUnit.scala 31:24]
  wire [6:0] func7 = io_instr[31:25]; // @[ControlUnit.scala 32:23]
  wire [2:0] func3 = io_instr[14:12]; // @[ControlUnit.scala 33:23]
  wire [4:0] subFormat = opcode[6:2]; // @[ControlUnit.scala 34:25]
  wire [3:0] funcCode = {func7[5],func3}; // @[ControlUnit.scala 35:27]
  wire [3:0] _GEN_1 = 4'h6 == funcCode ? 4'h1 : 4'h0; // @[ControlUnit.scala 65:24 74:28]
  wire [3:0] _GEN_2 = 4'hd == funcCode ? 4'h9 : _GEN_1; // @[ControlUnit.scala 65:24 73:29]
  wire [3:0] _GEN_3 = 4'h5 == funcCode ? 4'h8 : _GEN_2; // @[ControlUnit.scala 65:24 72:29]
  wire [3:0] _GEN_4 = 4'h4 == funcCode ? 4'h2 : _GEN_3; // @[ControlUnit.scala 65:24 71:29]
  wire [3:0] _GEN_5 = 4'h3 == funcCode ? 4'h7 : _GEN_4; // @[ControlUnit.scala 65:24 70:30]
  wire [3:0] _GEN_6 = 4'h2 == funcCode ? 4'h5 : _GEN_5; // @[ControlUnit.scala 65:24 69:29]
  wire [3:0] _GEN_7 = 4'h1 == funcCode ? 4'h6 : _GEN_6; // @[ControlUnit.scala 65:24 68:29]
  wire [3:0] _GEN_8 = 4'h8 == funcCode ? 4'h4 : _GEN_7; // @[ControlUnit.scala 65:24 67:29]
  wire [3:0] _GEN_9 = 4'h0 == funcCode ? 4'h3 : _GEN_8; // @[ControlUnit.scala 65:24 66:29]
  wire [3:0] _GEN_10 = ~funcCode[3] ? 4'h8 : 4'h9; // @[ControlUnit.scala 102:37 103:21 105:21]
  wire [3:0] _GEN_11 = 3'h5 == funcCode[2:0] ? _GEN_10 : 4'h0; // @[ControlUnit.scala 38:28 93:30]
  wire [3:0] _GEN_12 = 3'h1 == funcCode[2:0] ? 4'h6 : _GEN_11; // @[ControlUnit.scala 93:30 100:32]
  wire [3:0] _GEN_13 = 3'h7 == funcCode[2:0] ? 4'h0 : _GEN_12; // @[ControlUnit.scala 93:30 99:32]
  wire [3:0] _GEN_14 = 3'h6 == funcCode[2:0] ? 4'h1 : _GEN_13; // @[ControlUnit.scala 93:30 98:32]
  wire [3:0] _GEN_15 = 3'h4 == funcCode[2:0] ? 4'h2 : _GEN_14; // @[ControlUnit.scala 93:30 97:32]
  wire [3:0] _GEN_16 = 3'h3 == funcCode[2:0] ? 4'h7 : _GEN_15; // @[ControlUnit.scala 93:30 96:32]
  wire [3:0] _GEN_17 = 3'h2 == funcCode[2:0] ? 4'h5 : _GEN_16; // @[ControlUnit.scala 93:30 95:32]
  wire [3:0] _GEN_18 = 3'h0 == funcCode[2:0] ? 4'h3 : _GEN_17; // @[ControlUnit.scala 93:30 94:32]
  wire  _stall_T_1 = io_cpu_wait ? 1'h0 : 1'h1; // @[ControlUnit.scala 149:19]
  wire  _immBranch_T_1 = io_eq ? 1'h0 : 1'h1; // @[ControlUnit.scala 164:37]
  wire  _immBranch_T_2 = io_ge ? 1'h0 : 1'h1; // @[ControlUnit.scala 165:37]
  wire  _immBranch_T_4 = io_geu ? 1'h0 : 1'h1; // @[ControlUnit.scala 167:38]
  wire  _GEN_19 = 3'h7 == func3 & io_geu; // @[ControlUnit.scala 162:21 168:32 47:30]
  wire  _GEN_20 = 3'h6 == func3 ? _immBranch_T_4 : _GEN_19; // @[ControlUnit.scala 162:21 167:32]
  wire  _GEN_21 = 3'h5 == func3 ? io_ge : _GEN_20; // @[ControlUnit.scala 162:21 166:31]
  wire  _GEN_22 = 3'h4 == func3 ? _immBranch_T_2 : _GEN_21; // @[ControlUnit.scala 162:21 165:31]
  wire  _GEN_23 = 3'h1 == func3 ? _immBranch_T_1 : _GEN_22; // @[ControlUnit.scala 162:21 164:31]
  wire  _GEN_24 = 3'h0 == func3 ? io_eq : _GEN_23; // @[ControlUnit.scala 162:21 163:31]
  wire [2:0] _GEN_27 = 5'h1b == subFormat ? 3'h5 : 3'h0; // @[ControlUnit.scala 221:14 52:21 39:27]
  wire  _GEN_30 = 5'h5 == subFormat ? 1'h0 : 5'h1b == subFormat; // @[ControlUnit.scala 200:17 52:21]
  wire  _GEN_31 = 5'h5 == subFormat | 5'h1b == subFormat; // @[ControlUnit.scala 202:13 52:21]
  wire [2:0] _GEN_32 = 5'h5 == subFormat ? 3'h4 : _GEN_27; // @[ControlUnit.scala 208:14 52:21]
  wire  _GEN_35 = 5'hd == subFormat ? 1'h0 : _GEN_30; // @[ControlUnit.scala 184:17 52:21]
  wire  _GEN_37 = 5'hd == subFormat | _GEN_31; // @[ControlUnit.scala 186:13 52:21]
  wire [3:0] _GEN_38 = 5'hd == subFormat ? 4'hb : 4'h0; // @[ControlUnit.scala 192:15 52:21 38:28]
  wire [2:0] _GEN_39 = 5'hd == subFormat ? 3'h4 : _GEN_32; // @[ControlUnit.scala 194:14 52:21]
  wire  _GEN_40 = 5'hd == subFormat ? 1'h0 : 5'h5 == subFormat; // @[ControlUnit.scala 52:21 46:26]
  wire  _GEN_42 = 5'h18 == subFormat ? _GEN_24 : _GEN_35; // @[ControlUnit.scala 52:21]
  wire  _GEN_44 = 5'h18 == subFormat | _GEN_37; // @[ControlUnit.scala 171:13 52:21]
  wire  _GEN_45 = 5'h18 == subFormat ? 1'h0 : _GEN_37; // @[ControlUnit.scala 173:16 52:21]
  wire [2:0] _GEN_46 = 5'h18 == subFormat ? 3'h3 : _GEN_39; // @[ControlUnit.scala 177:14 52:21]
  wire  _GEN_47 = 5'h18 == subFormat ? 1'h0 : 5'hd == subFormat; // @[ControlUnit.scala 52:21 45:29]
  wire [3:0] _GEN_48 = 5'h18 == subFormat ? 4'h0 : _GEN_38; // @[ControlUnit.scala 52:21 38:28]
  wire  _GEN_49 = 5'h18 == subFormat ? 1'h0 : _GEN_40; // @[ControlUnit.scala 52:21 46:26]
  wire  _GEN_51 = 5'h8 == subFormat ? 1'h0 : _GEN_42; // @[ControlUnit.scala 147:17 52:21]
  wire  _GEN_53 = 5'h8 == subFormat ? _stall_T_1 : _GEN_44; // @[ControlUnit.scala 149:13 52:21]
  wire  _GEN_54 = 5'h8 == subFormat ? 1'h0 : _GEN_45; // @[ControlUnit.scala 151:16 52:21]
  wire [3:0] _GEN_56 = 5'h8 == subFormat ? 4'h3 : _GEN_48; // @[ControlUnit.scala 155:15 52:21]
  wire [2:0] _GEN_57 = 5'h8 == subFormat ? 3'h2 : _GEN_46; // @[ControlUnit.scala 157:14 52:21]
  wire  _GEN_59 = 5'h8 == subFormat ? 1'h0 : _GEN_47; // @[ControlUnit.scala 52:21 45:29]
  wire  _GEN_60 = 5'h8 == subFormat ? 1'h0 : _GEN_49; // @[ControlUnit.scala 52:21 46:26]
  wire  _GEN_61 = 5'h19 == subFormat ? 1'h0 : _GEN_60; // @[ControlUnit.scala 131:13 52:21]
  wire  _GEN_62 = 5'h19 == subFormat ? 1'h0 : _GEN_59; // @[ControlUnit.scala 132:16 52:21]
  wire  _GEN_64 = 5'h19 == subFormat | _GEN_53; // @[ControlUnit.scala 134:13 52:21]
  wire  _GEN_65 = 5'h19 == subFormat | _GEN_54; // @[ControlUnit.scala 136:16 52:21]
  wire  _GEN_67 = 5'h19 == subFormat ? 1'h0 : 5'h8 == subFormat; // @[ControlUnit.scala 138:16 52:21]
  wire [3:0] _GEN_68 = 5'h19 == subFormat ? 4'ha : _GEN_56; // @[ControlUnit.scala 140:15 52:21]
  wire [2:0] _GEN_69 = 5'h19 == subFormat ? 3'h1 : _GEN_57; // @[ControlUnit.scala 142:14 52:21]
  wire  _GEN_71 = 5'h19 == subFormat ? 1'h0 : _GEN_51; // @[ControlUnit.scala 52:21 47:30]
  wire  _GEN_73 = 5'h0 == subFormat | _GEN_67; // @[ControlUnit.scala 114:14 52:21]
  wire  _GEN_75 = 5'h0 == subFormat | _GEN_62; // @[ControlUnit.scala 116:16 52:21]
  wire  _GEN_76 = 5'h0 == subFormat ? 1'h0 : _GEN_71; // @[ControlUnit.scala 117:17 52:21]
  wire  _GEN_77 = 5'h0 == subFormat ? 1'h0 : 5'h19 == subFormat; // @[ControlUnit.scala 118:17 52:21]
  wire  _GEN_78 = 5'h0 == subFormat ? io_cpu_ready : _GEN_64; // @[ControlUnit.scala 119:13 52:21]
  wire  _GEN_79 = 5'h0 == subFormat | _GEN_65; // @[ControlUnit.scala 121:16 52:21]
  wire  _GEN_81 = 5'h0 == subFormat ? 1'h0 : _GEN_67; // @[ControlUnit.scala 123:16 52:21]
  wire [3:0] _GEN_82 = 5'h0 == subFormat ? 4'h3 : _GEN_68; // @[ControlUnit.scala 125:15 52:21]
  wire [2:0] _GEN_83 = 5'h0 == subFormat ? 3'h1 : _GEN_69; // @[ControlUnit.scala 127:14 52:21]
  wire  _GEN_84 = 5'h0 == subFormat ? 1'h0 : _GEN_61; // @[ControlUnit.scala 52:21 46:26]
  wire  _GEN_85 = 5'h4 == subFormat | _GEN_73; // @[ControlUnit.scala 52:21 82:14]
  wire  _GEN_86 = 5'h4 == subFormat ? 1'h0 : 5'h0 == subFormat; // @[ControlUnit.scala 52:21 83:14]
  wire  _GEN_87 = 5'h4 == subFormat | _GEN_75; // @[ControlUnit.scala 52:21 84:16]
  wire  _GEN_88 = 5'h4 == subFormat ? 1'h0 : _GEN_76; // @[ControlUnit.scala 52:21 85:17]
  wire  _GEN_89 = 5'h4 == subFormat ? 1'h0 : _GEN_77; // @[ControlUnit.scala 52:21 86:17]
  wire  _GEN_90 = 5'h4 == subFormat | _GEN_78; // @[ControlUnit.scala 52:21 87:13]
  wire  _GEN_91 = 5'h4 == subFormat | _GEN_79; // @[ControlUnit.scala 52:21 89:16]
  wire  _GEN_93 = 5'h4 == subFormat ? 1'h0 : _GEN_81; // @[ControlUnit.scala 52:21 91:16]
  wire [3:0] _GEN_94 = 5'h4 == subFormat ? _GEN_18 : _GEN_82; // @[ControlUnit.scala 52:21]
  wire [2:0] _GEN_95 = 5'h4 == subFormat ? 3'h1 : _GEN_83; // @[ControlUnit.scala 110:14 52:21]
  wire  _GEN_96 = 5'h4 == subFormat ? 1'h0 : _GEN_84; // @[ControlUnit.scala 52:21 46:26]
  wire [1:0] _GEN_109 = 2'h2 == func3[1:0] ? 2'h3 : 2'h0; // @[ControlUnit.scala 238:21 241:28 50:30]
  wire [1:0] _GEN_110 = 2'h1 == func3[1:0] ? 2'h2 : _GEN_109; // @[ControlUnit.scala 238:21 240:28]
  wire [1:0] storeType = 2'h0 == func3[1:0] ? 2'h1 : _GEN_110; // @[ControlUnit.scala 238:21 239:28]
  assign io_format = 5'hc == subFormat ? 3'h0 : _GEN_95; // @[ControlUnit.scala 52:21 78:14]
  assign io_ALUCtrl = 5'hc == subFormat ? _GEN_9 : _GEN_94; // @[ControlUnit.scala 52:21]
  assign io_regWrite = 5'hc == subFormat | _GEN_91; // @[ControlUnit.scala 52:21 61:16]
  assign io_memWrite = 5'hc == subFormat ? 1'h0 : _GEN_93; // @[ControlUnit.scala 52:21 63:16]
  assign io_memRead = 5'hc == subFormat ? 1'h0 : _GEN_86; // @[ControlUnit.scala 52:21 62:15]
  assign io_rs2Imm = 5'hc == subFormat ? 1'h0 : _GEN_85; // @[ControlUnit.scala 52:21 54:14]
  assign io_aluMem = 5'hc == subFormat ? 1'h0 : _GEN_86; // @[ControlUnit.scala 52:21 55:14]
  assign io_pcAluMem = 5'hc == subFormat | _GEN_87; // @[ControlUnit.scala 52:21 56:16]
  assign io_pcImm = 5'hc == subFormat ? 1'h0 : _GEN_96; // @[ControlUnit.scala 52:21 46:26]
  assign io_immBranch = 5'hc == subFormat ? 1'h0 : _GEN_88; // @[ControlUnit.scala 52:21 57:17]
  assign io_aluBranch = 5'hc == subFormat ? 1'h0 : _GEN_89; // @[ControlUnit.scala 52:21 58:17]
  assign io_stall = 5'hc == subFormat | _GEN_90; // @[ControlUnit.scala 52:21 59:13]
  assign io_storeType = io_memRead | io_memWrite ? storeType : 2'h0; // @[ControlUnit.scala 243:22]
endmodule
module RegisterFile(
  input         clock,
  input         reset,
  input  [4:0]  io_readAddr1,
  input  [4:0]  io_readAddr2,
  input  [4:0]  io_writeAddr,
  input  [31:0] io_writeData,
  input         io_writeEn,
  output [31:0] io_readData1,
  output [31:0] io_readData2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] registerFile_0; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_1; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_2; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_3; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_4; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_5; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_6; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_7; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_8; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_9; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_10; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_11; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_12; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_13; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_14; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_15; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_16; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_17; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_18; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_19; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_20; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_21; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_22; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_23; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_24; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_25; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_26; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_27; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_28; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_29; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_30; // @[RegisterFile.scala 19:29]
  reg [31:0] registerFile_31; // @[RegisterFile.scala 19:29]
  wire [31:0] _GEN_1 = 5'h1 == io_readAddr1 ? $signed(registerFile_1) : $signed(registerFile_0); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_2 = 5'h2 == io_readAddr1 ? $signed(registerFile_2) : $signed(_GEN_1); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_3 = 5'h3 == io_readAddr1 ? $signed(registerFile_3) : $signed(_GEN_2); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_4 = 5'h4 == io_readAddr1 ? $signed(registerFile_4) : $signed(_GEN_3); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_5 = 5'h5 == io_readAddr1 ? $signed(registerFile_5) : $signed(_GEN_4); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_6 = 5'h6 == io_readAddr1 ? $signed(registerFile_6) : $signed(_GEN_5); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_7 = 5'h7 == io_readAddr1 ? $signed(registerFile_7) : $signed(_GEN_6); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_8 = 5'h8 == io_readAddr1 ? $signed(registerFile_8) : $signed(_GEN_7); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_9 = 5'h9 == io_readAddr1 ? $signed(registerFile_9) : $signed(_GEN_8); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_10 = 5'ha == io_readAddr1 ? $signed(registerFile_10) : $signed(_GEN_9); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_11 = 5'hb == io_readAddr1 ? $signed(registerFile_11) : $signed(_GEN_10); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_12 = 5'hc == io_readAddr1 ? $signed(registerFile_12) : $signed(_GEN_11); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_13 = 5'hd == io_readAddr1 ? $signed(registerFile_13) : $signed(_GEN_12); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_14 = 5'he == io_readAddr1 ? $signed(registerFile_14) : $signed(_GEN_13); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_15 = 5'hf == io_readAddr1 ? $signed(registerFile_15) : $signed(_GEN_14); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_16 = 5'h10 == io_readAddr1 ? $signed(registerFile_16) : $signed(_GEN_15); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_17 = 5'h11 == io_readAddr1 ? $signed(registerFile_17) : $signed(_GEN_16); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_18 = 5'h12 == io_readAddr1 ? $signed(registerFile_18) : $signed(_GEN_17); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_19 = 5'h13 == io_readAddr1 ? $signed(registerFile_19) : $signed(_GEN_18); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_20 = 5'h14 == io_readAddr1 ? $signed(registerFile_20) : $signed(_GEN_19); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_21 = 5'h15 == io_readAddr1 ? $signed(registerFile_21) : $signed(_GEN_20); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_22 = 5'h16 == io_readAddr1 ? $signed(registerFile_22) : $signed(_GEN_21); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_23 = 5'h17 == io_readAddr1 ? $signed(registerFile_23) : $signed(_GEN_22); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_24 = 5'h18 == io_readAddr1 ? $signed(registerFile_24) : $signed(_GEN_23); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_25 = 5'h19 == io_readAddr1 ? $signed(registerFile_25) : $signed(_GEN_24); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_26 = 5'h1a == io_readAddr1 ? $signed(registerFile_26) : $signed(_GEN_25); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_27 = 5'h1b == io_readAddr1 ? $signed(registerFile_27) : $signed(_GEN_26); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_28 = 5'h1c == io_readAddr1 ? $signed(registerFile_28) : $signed(_GEN_27); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_29 = 5'h1d == io_readAddr1 ? $signed(registerFile_29) : $signed(_GEN_28); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_30 = 5'h1e == io_readAddr1 ? $signed(registerFile_30) : $signed(_GEN_29); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_31 = 5'h1f == io_readAddr1 ? $signed(registerFile_31) : $signed(_GEN_30); // @[RegisterFile.scala 23:{18,18}]
  wire [31:0] _GEN_34 = 5'h1 == io_readAddr2 ? $signed(registerFile_1) : $signed(registerFile_0); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_35 = 5'h2 == io_readAddr2 ? $signed(registerFile_2) : $signed(_GEN_34); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_36 = 5'h3 == io_readAddr2 ? $signed(registerFile_3) : $signed(_GEN_35); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_37 = 5'h4 == io_readAddr2 ? $signed(registerFile_4) : $signed(_GEN_36); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_38 = 5'h5 == io_readAddr2 ? $signed(registerFile_5) : $signed(_GEN_37); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_39 = 5'h6 == io_readAddr2 ? $signed(registerFile_6) : $signed(_GEN_38); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_40 = 5'h7 == io_readAddr2 ? $signed(registerFile_7) : $signed(_GEN_39); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_41 = 5'h8 == io_readAddr2 ? $signed(registerFile_8) : $signed(_GEN_40); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_42 = 5'h9 == io_readAddr2 ? $signed(registerFile_9) : $signed(_GEN_41); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_43 = 5'ha == io_readAddr2 ? $signed(registerFile_10) : $signed(_GEN_42); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_44 = 5'hb == io_readAddr2 ? $signed(registerFile_11) : $signed(_GEN_43); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_45 = 5'hc == io_readAddr2 ? $signed(registerFile_12) : $signed(_GEN_44); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_46 = 5'hd == io_readAddr2 ? $signed(registerFile_13) : $signed(_GEN_45); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_47 = 5'he == io_readAddr2 ? $signed(registerFile_14) : $signed(_GEN_46); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_48 = 5'hf == io_readAddr2 ? $signed(registerFile_15) : $signed(_GEN_47); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_49 = 5'h10 == io_readAddr2 ? $signed(registerFile_16) : $signed(_GEN_48); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_50 = 5'h11 == io_readAddr2 ? $signed(registerFile_17) : $signed(_GEN_49); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_51 = 5'h12 == io_readAddr2 ? $signed(registerFile_18) : $signed(_GEN_50); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_52 = 5'h13 == io_readAddr2 ? $signed(registerFile_19) : $signed(_GEN_51); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_53 = 5'h14 == io_readAddr2 ? $signed(registerFile_20) : $signed(_GEN_52); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_54 = 5'h15 == io_readAddr2 ? $signed(registerFile_21) : $signed(_GEN_53); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_55 = 5'h16 == io_readAddr2 ? $signed(registerFile_22) : $signed(_GEN_54); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_56 = 5'h17 == io_readAddr2 ? $signed(registerFile_23) : $signed(_GEN_55); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_57 = 5'h18 == io_readAddr2 ? $signed(registerFile_24) : $signed(_GEN_56); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_58 = 5'h19 == io_readAddr2 ? $signed(registerFile_25) : $signed(_GEN_57); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_59 = 5'h1a == io_readAddr2 ? $signed(registerFile_26) : $signed(_GEN_58); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_60 = 5'h1b == io_readAddr2 ? $signed(registerFile_27) : $signed(_GEN_59); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_61 = 5'h1c == io_readAddr2 ? $signed(registerFile_28) : $signed(_GEN_60); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_62 = 5'h1d == io_readAddr2 ? $signed(registerFile_29) : $signed(_GEN_61); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_63 = 5'h1e == io_readAddr2 ? $signed(registerFile_30) : $signed(_GEN_62); // @[RegisterFile.scala 29:{18,18}]
  wire [31:0] _GEN_64 = 5'h1f == io_readAddr2 ? $signed(registerFile_31) : $signed(_GEN_63); // @[RegisterFile.scala 29:{18,18}]
  assign io_readData1 = io_readAddr1 == 5'h0 ? $signed(32'sh0) : $signed(_GEN_31); // @[RegisterFile.scala 20:30 21:18 23:18]
  assign io_readData2 = io_readAddr2 == 5'h0 ? $signed(32'sh0) : $signed(_GEN_64); // @[RegisterFile.scala 26:30 27:18 29:18]
  always @(posedge clock) begin
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_0 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h0 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_0 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_1 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h1 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_1 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_2 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h2 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_2 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_3 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h3 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_3 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_4 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h4 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_4 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_5 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h5 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_5 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_6 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h6 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_6 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_7 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h7 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_7 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_8 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h8 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_8 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_9 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h9 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_9 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_10 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'ha == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_10 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_11 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'hb == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_11 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_12 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'hc == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_12 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_13 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'hd == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_13 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_14 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'he == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_14 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_15 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'hf == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_15 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_16 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h10 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_16 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_17 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h11 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_17 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_18 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h12 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_18 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_19 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h13 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_19 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_20 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h14 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_20 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_21 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h15 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_21 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_22 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h16 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_22 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_23 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h17 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_23 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_24 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h18 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_24 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_25 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h19 == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_25 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_26 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h1a == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_26 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_27 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h1b == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_27 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_28 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h1c == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_28 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_29 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h1d == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_29 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_30 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h1e == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_30 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
    if (reset) begin // @[RegisterFile.scala 19:29]
      registerFile_31 <= 32'sh0; // @[RegisterFile.scala 19:29]
    end else if (io_writeEn) begin // @[RegisterFile.scala 32:20]
      if (5'h1f == io_writeAddr) begin // @[RegisterFile.scala 33:32]
        registerFile_31 <= io_writeData; // @[RegisterFile.scala 33:32]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  registerFile_0 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  registerFile_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  registerFile_2 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  registerFile_3 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  registerFile_4 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  registerFile_5 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  registerFile_6 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  registerFile_7 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  registerFile_8 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  registerFile_9 = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  registerFile_10 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  registerFile_11 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  registerFile_12 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  registerFile_13 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  registerFile_14 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  registerFile_15 = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  registerFile_16 = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  registerFile_17 = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  registerFile_18 = _RAND_18[31:0];
  _RAND_19 = {1{`RANDOM}};
  registerFile_19 = _RAND_19[31:0];
  _RAND_20 = {1{`RANDOM}};
  registerFile_20 = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  registerFile_21 = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  registerFile_22 = _RAND_22[31:0];
  _RAND_23 = {1{`RANDOM}};
  registerFile_23 = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  registerFile_24 = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  registerFile_25 = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  registerFile_26 = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  registerFile_27 = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  registerFile_28 = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  registerFile_29 = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  registerFile_30 = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  registerFile_31 = _RAND_31[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ALU(
  input  [3:0]  io_ALUCtrl,
  input  [31:0] io_A,
  input  [31:0] io_B,
  output [31:0] io_ALUOut,
  output        io_eq,
  output        io_ge,
  output        io_geu
);
  wire [4:0] shamt = io_B[4:0]; // @[ALU.scala 22:16]
  wire [31:0] _res_T_1 = $signed(io_A) & $signed(io_B); // @[ALU.scala 31:26]
  wire [31:0] _res_T_3 = $signed(io_A) | $signed(io_B); // @[ALU.scala 32:25]
  wire [31:0] _res_T_5 = $signed(io_A) ^ $signed(io_B); // @[ALU.scala 33:26]
  wire [31:0] _res_T_8 = $signed(io_A) + $signed(io_B); // @[ALU.scala 34:26]
  wire [31:0] _res_T_11 = $signed(io_A) - $signed(io_B); // @[ALU.scala 35:26]
  wire [1:0] _res_T_13 = $signed(io_A) < $signed(io_B) ? $signed(2'sh1) : $signed(2'sh0); // @[ALU.scala 36:27]
  wire [62:0] _GEN_14 = {{31{io_A[31]}},io_A}; // @[ALU.scala 37:26]
  wire [62:0] _res_T_14 = $signed(_GEN_14) << shamt; // @[ALU.scala 37:26]
  wire [1:0] _res_T_18 = io_A < io_B ? $signed(2'sh1) : $signed(2'sh0); // @[ALU.scala 38:28]
  wire [31:0] _res_T_21 = io_A >> shamt; // @[ALU.scala 39:44]
  wire [31:0] _res_T_22 = $signed(io_A) >>> shamt; // @[ALU.scala 40:26]
  wire [1:0] _res_T_27 = ~2'sh1; // @[ALU.scala 41:35]
  wire [31:0] _GEN_12 = {{30{_res_T_27[1]}},_res_T_27}; // @[ALU.scala 41:33]
  wire [31:0] _res_T_29 = $signed(_res_T_8) & $signed(_GEN_12); // @[ALU.scala 41:33]
  wire [31:0] _GEN_0 = 4'hb == io_ALUCtrl ? $signed(io_B) : $signed(32'sh0); // @[ALU.scala 30:22 24:24 42:25]
  wire [31:0] _GEN_1 = 4'ha == io_ALUCtrl ? $signed(_res_T_29) : $signed(_GEN_0); // @[ALU.scala 30:22 41:22]
  wire [31:0] _GEN_2 = 4'h9 == io_ALUCtrl ? $signed(_res_T_22) : $signed(_GEN_1); // @[ALU.scala 30:22 40:21]
  wire [31:0] _GEN_3 = 4'h8 == io_ALUCtrl ? $signed(_res_T_21) : $signed(_GEN_2); // @[ALU.scala 30:22 39:21]
  wire [31:0] _GEN_4 = 4'h7 == io_ALUCtrl ? $signed({{30{_res_T_18[1]}},_res_T_18}) : $signed(_GEN_3); // @[ALU.scala 30:22 38:22]
  wire [62:0] _GEN_5 = 4'h6 == io_ALUCtrl ? $signed(_res_T_14) : $signed({{31{_GEN_4[31]}},_GEN_4}); // @[ALU.scala 30:22 37:21]
  wire [62:0] _GEN_6 = 4'h5 == io_ALUCtrl ? $signed({{61{_res_T_13[1]}},_res_T_13}) : $signed(_GEN_5); // @[ALU.scala 30:22 36:21]
  wire [62:0] _GEN_7 = 4'h4 == io_ALUCtrl ? $signed({{31{_res_T_11[31]}},_res_T_11}) : $signed(_GEN_6); // @[ALU.scala 30:22 35:21]
  wire [62:0] _GEN_8 = 4'h3 == io_ALUCtrl ? $signed({{31{_res_T_8[31]}},_res_T_8}) : $signed(_GEN_7); // @[ALU.scala 30:22 34:21]
  wire [62:0] _GEN_9 = 4'h2 == io_ALUCtrl ? $signed({{31{_res_T_5[31]}},_res_T_5}) : $signed(_GEN_8); // @[ALU.scala 30:22 33:21]
  wire [62:0] _GEN_10 = 4'h1 == io_ALUCtrl ? $signed({{31{_res_T_3[31]}},_res_T_3}) : $signed(_GEN_9); // @[ALU.scala 30:22 32:20]
  wire [62:0] _GEN_11 = 4'h0 == io_ALUCtrl ? $signed({{31{_res_T_1[31]}},_res_T_1}) : $signed(_GEN_10); // @[ALU.scala 30:22 31:21]
  assign io_ALUOut = _GEN_11[31:0]; // @[ALU.scala 24:24]
  assign io_eq = $signed(io_A) == $signed(io_B); // @[ALU.scala 26:18]
  assign io_ge = $signed(io_A) >= $signed(io_B); // @[ALU.scala 27:18]
  assign io_geu = io_A >= io_B; // @[ALU.scala 28:26]
endmodule
module ImmGen(
  input  [31:0] io_in,
  input  [2:0]  io_format,
  output [31:0] io_out
);
  wire [11:0] _res_T_1 = io_in[31:20]; // @[ImmGen.scala 19:33]
  wire [11:0] _res_T_5 = {io_in[31:25],io_in[11:7]}; // @[ImmGen.scala 20:48]
  wire [12:0] _res_T_14 = {io_in[31],io_in[7],io_in[30:25],io_in[11:8],1'h0}; // @[ImmGen.scala 22:71]
  wire [31:0] _res_T_17 = {io_in[31:12],12'h0}; // @[ImmGen.scala 24:48]
  wire [20:0] _res_T_28 = {io_in[31],io_in[19:12],io_in[20],io_in[30:25],io_in[24:21],1'h0}; // @[ImmGen.scala 28:10]
  wire [31:0] _GEN_0 = 3'h5 == io_format ? $signed({{11{_res_T_28[20]}},_res_T_28}) : $signed(32'sh0); // @[ImmGen.scala 18:18 26:11 16:24]
  wire [31:0] _GEN_1 = 3'h4 == io_format ? $signed(_res_T_17) : $signed(_GEN_0); // @[ImmGen.scala 18:18 24:19]
  wire [31:0] _GEN_2 = 3'h3 == io_format ? $signed({{19{_res_T_14[12]}},_res_T_14}) : $signed(_GEN_1); // @[ImmGen.scala 18:18 22:11]
  wire [31:0] _GEN_3 = 3'h2 == io_format ? $signed({{20{_res_T_5[11]}},_res_T_5}) : $signed(_GEN_2); // @[ImmGen.scala 18:18 20:19]
  assign io_out = 3'h1 == io_format ? $signed({{20{_res_T_1[11]}},_res_T_1}) : $signed(_GEN_3); // @[ImmGen.scala 18:18 19:19]
endmodule
module PC(
  input         clock,
  input         reset,
  input  [31:0] io_inAddr,
  output [31:0] io_outAddr
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] io_outAddr_REG; // @[OtherComponents.scala 14:24]
  assign io_outAddr = io_outAddr_REG; // @[OtherComponents.scala 14:14]
  always @(posedge clock) begin
    if (reset) begin // @[OtherComponents.scala 14:24]
      io_outAddr_REG <= 32'h0; // @[OtherComponents.scala 14:24]
    end else begin
      io_outAddr_REG <= io_inAddr; // @[OtherComponents.scala 14:24]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  io_outAddr_REG = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module PCIncrementer(
  input  [31:0] io_pc,
  output [31:0] io_outAddr
);
  assign io_outAddr = io_pc + 32'h4; // @[OtherComponents.scala 23:23]
endmodule
module BranchAdder(
  input  [31:0] io_pc,
  input  [31:0] io_imm,
  output [31:0] io_outAddr
);
  assign io_outAddr = $signed(io_pc) + $signed(io_imm); // @[OtherComponents.scala 33:41]
endmodule
module PcALUMemMux(
  input         io_pcAluMem,
  input  [31:0] io_aluMem,
  input  [31:0] io_pcImm,
  output [31:0] io_out
);
  assign io_out = io_pcAluMem ? $signed(io_aluMem) : $signed(io_pcImm); // @[OtherComponents.scala 66:16]
endmodule
module Rs2ImmMux(
  input         io_rs2Imm,
  input  [31:0] io_rs2,
  input  [31:0] io_imm,
  output [31:0] io_out
);
  assign io_out = io_rs2Imm ? $signed(io_imm) : $signed(io_rs2); // @[OtherComponents.scala 44:16]
endmodule
module PcImmMux(
  input         io_pcImm,
  input  [31:0] io_pcPc4,
  input  [31:0] io_branch,
  output [31:0] io_out
);
  assign io_out = io_pcImm ? io_branch : io_pcPc4; // @[OtherComponents.scala 77:16]
endmodule
module ALUBranchMux(
  input         io_aluBranch,
  input  [31:0] io_pc4Branch,
  input  [31:0] io_ALUOut,
  output [31:0] io_out
);
  assign io_out = io_aluBranch ? io_ALUOut : io_pc4Branch; // @[OtherComponents.scala 99:16]
endmodule
module PcStallMux(
  input         io_stall,
  input  [31:0] io_next,
  input  [31:0] io_current,
  output [31:0] io_out
);
  assign io_out = io_stall ? io_next : io_current; // @[OtherComponents.scala 110:16]
endmodule
module LoadSelector(
  input  [2:0]  io_func3,
  input  [31:0] io_inData,
  output [31:0] io_outData
);
  wire [7:0] _res_T_1 = io_inData[7:0]; // @[LoadSelector.scala 19:43]
  wire [15:0] _res_T_3 = io_inData[15:0]; // @[LoadSelector.scala 20:44]
  wire [31:0] _res_T_7 = {24'h0,io_inData[7:0]}; // @[LoadSelector.scala 22:58]
  wire [31:0] _res_T_10 = {16'h0,io_inData[15:0]}; // @[LoadSelector.scala 23:59]
  wire [31:0] _GEN_0 = 3'h5 == io_func3 ? $signed(_res_T_10) : $signed(32'sh0); // @[LoadSelector.scala 18:20 16:24 23:24]
  wire [31:0] _GEN_1 = 3'h4 == io_func3 ? $signed(_res_T_7) : $signed(_GEN_0); // @[LoadSelector.scala 18:20 22:24]
  wire [31:0] _GEN_2 = 3'h2 == io_func3 ? $signed(io_inData) : $signed(_GEN_1); // @[LoadSelector.scala 18:20 21:24]
  wire [31:0] _GEN_3 = 3'h1 == io_func3 ? $signed({{16{_res_T_3[15]}},_res_T_3}) : $signed(_GEN_2); // @[LoadSelector.scala 18:20 20:24]
  assign io_outData = 3'h0 == io_func3 ? $signed({{24{_res_T_1[7]}},_res_T_1}) : $signed(_GEN_3); // @[LoadSelector.scala 18:20 19:24]
endmodule
module Core(
  input         clock,
  input         reset,
  input  [31:0] io_instr,
  input  [31:0] io_memReadData,
  input         io_cpu_wait,
  input         io_cpu_ready,
  output [8:0]  io_instrAddrs,
  output [31:0] io_ALUOut,
  output [31:0] io_memWriteData,
  output        io_memWrite,
  output [1:0]  io_storeType
);
  wire [31:0] controlUnit_io_instr; // @[Core.scala 23:27]
  wire  controlUnit_io_eq; // @[Core.scala 23:27]
  wire  controlUnit_io_ge; // @[Core.scala 23:27]
  wire  controlUnit_io_geu; // @[Core.scala 23:27]
  wire  controlUnit_io_cpu_wait; // @[Core.scala 23:27]
  wire  controlUnit_io_cpu_ready; // @[Core.scala 23:27]
  wire [2:0] controlUnit_io_format; // @[Core.scala 23:27]
  wire [3:0] controlUnit_io_ALUCtrl; // @[Core.scala 23:27]
  wire  controlUnit_io_regWrite; // @[Core.scala 23:27]
  wire  controlUnit_io_memWrite; // @[Core.scala 23:27]
  wire  controlUnit_io_memRead; // @[Core.scala 23:27]
  wire  controlUnit_io_rs2Imm; // @[Core.scala 23:27]
  wire  controlUnit_io_aluMem; // @[Core.scala 23:27]
  wire  controlUnit_io_pcAluMem; // @[Core.scala 23:27]
  wire  controlUnit_io_pcImm; // @[Core.scala 23:27]
  wire  controlUnit_io_immBranch; // @[Core.scala 23:27]
  wire  controlUnit_io_aluBranch; // @[Core.scala 23:27]
  wire  controlUnit_io_stall; // @[Core.scala 23:27]
  wire [1:0] controlUnit_io_storeType; // @[Core.scala 23:27]
  wire  registerFile_clock; // @[Core.scala 24:28]
  wire  registerFile_reset; // @[Core.scala 24:28]
  wire [4:0] registerFile_io_readAddr1; // @[Core.scala 24:28]
  wire [4:0] registerFile_io_readAddr2; // @[Core.scala 24:28]
  wire [4:0] registerFile_io_writeAddr; // @[Core.scala 24:28]
  wire [31:0] registerFile_io_writeData; // @[Core.scala 24:28]
  wire  registerFile_io_writeEn; // @[Core.scala 24:28]
  wire [31:0] registerFile_io_readData1; // @[Core.scala 24:28]
  wire [31:0] registerFile_io_readData2; // @[Core.scala 24:28]
  wire [3:0] alu_io_ALUCtrl; // @[Core.scala 25:19]
  wire [31:0] alu_io_A; // @[Core.scala 25:19]
  wire [31:0] alu_io_B; // @[Core.scala 25:19]
  wire [31:0] alu_io_ALUOut; // @[Core.scala 25:19]
  wire  alu_io_eq; // @[Core.scala 25:19]
  wire  alu_io_ge; // @[Core.scala 25:19]
  wire  alu_io_geu; // @[Core.scala 25:19]
  wire [31:0] immGen_io_in; // @[Core.scala 26:22]
  wire [2:0] immGen_io_format; // @[Core.scala 26:22]
  wire [31:0] immGen_io_out; // @[Core.scala 26:22]
  wire  pc_clock; // @[Core.scala 27:18]
  wire  pc_reset; // @[Core.scala 27:18]
  wire [31:0] pc_io_inAddr; // @[Core.scala 27:18]
  wire [31:0] pc_io_outAddr; // @[Core.scala 27:18]
  wire [31:0] pcIncrementer_io_pc; // @[Core.scala 28:29]
  wire [31:0] pcIncrementer_io_outAddr; // @[Core.scala 28:29]
  wire [31:0] branchAdder_io_pc; // @[Core.scala 29:27]
  wire [31:0] branchAdder_io_imm; // @[Core.scala 29:27]
  wire [31:0] branchAdder_io_outAddr; // @[Core.scala 29:27]
  wire  pcAluMemMux_io_pcAluMem; // @[Core.scala 30:27]
  wire [31:0] pcAluMemMux_io_aluMem; // @[Core.scala 30:27]
  wire [31:0] pcAluMemMux_io_pcImm; // @[Core.scala 30:27]
  wire [31:0] pcAluMemMux_io_out; // @[Core.scala 30:27]
  wire  rs2ImmMux_io_rs2Imm; // @[Core.scala 31:25]
  wire [31:0] rs2ImmMux_io_rs2; // @[Core.scala 31:25]
  wire [31:0] rs2ImmMux_io_imm; // @[Core.scala 31:25]
  wire [31:0] rs2ImmMux_io_out; // @[Core.scala 31:25]
  wire  pcImmMux_io_pcImm; // @[Core.scala 32:24]
  wire [31:0] pcImmMux_io_pcPc4; // @[Core.scala 32:24]
  wire [31:0] pcImmMux_io_branch; // @[Core.scala 32:24]
  wire [31:0] pcImmMux_io_out; // @[Core.scala 32:24]
  wire  aluMemMux_io_rs2Imm; // @[Core.scala 33:25]
  wire [31:0] aluMemMux_io_rs2; // @[Core.scala 33:25]
  wire [31:0] aluMemMux_io_imm; // @[Core.scala 33:25]
  wire [31:0] aluMemMux_io_out; // @[Core.scala 33:25]
  wire  immBranchMux_io_pcImm; // @[Core.scala 34:28]
  wire [31:0] immBranchMux_io_pcPc4; // @[Core.scala 34:28]
  wire [31:0] immBranchMux_io_branch; // @[Core.scala 34:28]
  wire [31:0] immBranchMux_io_out; // @[Core.scala 34:28]
  wire  aluBranchMux_io_aluBranch; // @[Core.scala 35:28]
  wire [31:0] aluBranchMux_io_pc4Branch; // @[Core.scala 35:28]
  wire [31:0] aluBranchMux_io_ALUOut; // @[Core.scala 35:28]
  wire [31:0] aluBranchMux_io_out; // @[Core.scala 35:28]
  wire  pcStall_io_stall; // @[Core.scala 36:23]
  wire [31:0] pcStall_io_next; // @[Core.scala 36:23]
  wire [31:0] pcStall_io_current; // @[Core.scala 36:23]
  wire [31:0] pcStall_io_out; // @[Core.scala 36:23]
  wire [2:0] loadSelector_io_func3; // @[Core.scala 37:28]
  wire [31:0] loadSelector_io_inData; // @[Core.scala 37:28]
  wire [31:0] loadSelector_io_outData; // @[Core.scala 37:28]
  wire [31:0] _io_instrAddrs_T = {{2'd0}, pc_io_outAddr[31:2]}; // @[Core.scala 100:35]
  ControlUnit controlUnit ( // @[Core.scala 23:27]
    .io_instr(controlUnit_io_instr),
    .io_eq(controlUnit_io_eq),
    .io_ge(controlUnit_io_ge),
    .io_geu(controlUnit_io_geu),
    .io_cpu_wait(controlUnit_io_cpu_wait),
    .io_cpu_ready(controlUnit_io_cpu_ready),
    .io_format(controlUnit_io_format),
    .io_ALUCtrl(controlUnit_io_ALUCtrl),
    .io_regWrite(controlUnit_io_regWrite),
    .io_memWrite(controlUnit_io_memWrite),
    .io_memRead(controlUnit_io_memRead),
    .io_rs2Imm(controlUnit_io_rs2Imm),
    .io_aluMem(controlUnit_io_aluMem),
    .io_pcAluMem(controlUnit_io_pcAluMem),
    .io_pcImm(controlUnit_io_pcImm),
    .io_immBranch(controlUnit_io_immBranch),
    .io_aluBranch(controlUnit_io_aluBranch),
    .io_stall(controlUnit_io_stall),
    .io_storeType(controlUnit_io_storeType)
  );
  RegisterFile registerFile ( // @[Core.scala 24:28]
    .clock(registerFile_clock),
    .reset(registerFile_reset),
    .io_readAddr1(registerFile_io_readAddr1),
    .io_readAddr2(registerFile_io_readAddr2),
    .io_writeAddr(registerFile_io_writeAddr),
    .io_writeData(registerFile_io_writeData),
    .io_writeEn(registerFile_io_writeEn),
    .io_readData1(registerFile_io_readData1),
    .io_readData2(registerFile_io_readData2)
  );
  ALU alu ( // @[Core.scala 25:19]
    .io_ALUCtrl(alu_io_ALUCtrl),
    .io_A(alu_io_A),
    .io_B(alu_io_B),
    .io_ALUOut(alu_io_ALUOut),
    .io_eq(alu_io_eq),
    .io_ge(alu_io_ge),
    .io_geu(alu_io_geu)
  );
  ImmGen immGen ( // @[Core.scala 26:22]
    .io_in(immGen_io_in),
    .io_format(immGen_io_format),
    .io_out(immGen_io_out)
  );
  PC pc ( // @[Core.scala 27:18]
    .clock(pc_clock),
    .reset(pc_reset),
    .io_inAddr(pc_io_inAddr),
    .io_outAddr(pc_io_outAddr)
  );
  PCIncrementer pcIncrementer ( // @[Core.scala 28:29]
    .io_pc(pcIncrementer_io_pc),
    .io_outAddr(pcIncrementer_io_outAddr)
  );
  BranchAdder branchAdder ( // @[Core.scala 29:27]
    .io_pc(branchAdder_io_pc),
    .io_imm(branchAdder_io_imm),
    .io_outAddr(branchAdder_io_outAddr)
  );
  PcALUMemMux pcAluMemMux ( // @[Core.scala 30:27]
    .io_pcAluMem(pcAluMemMux_io_pcAluMem),
    .io_aluMem(pcAluMemMux_io_aluMem),
    .io_pcImm(pcAluMemMux_io_pcImm),
    .io_out(pcAluMemMux_io_out)
  );
  Rs2ImmMux rs2ImmMux ( // @[Core.scala 31:25]
    .io_rs2Imm(rs2ImmMux_io_rs2Imm),
    .io_rs2(rs2ImmMux_io_rs2),
    .io_imm(rs2ImmMux_io_imm),
    .io_out(rs2ImmMux_io_out)
  );
  PcImmMux pcImmMux ( // @[Core.scala 32:24]
    .io_pcImm(pcImmMux_io_pcImm),
    .io_pcPc4(pcImmMux_io_pcPc4),
    .io_branch(pcImmMux_io_branch),
    .io_out(pcImmMux_io_out)
  );
  Rs2ImmMux aluMemMux ( // @[Core.scala 33:25]
    .io_rs2Imm(aluMemMux_io_rs2Imm),
    .io_rs2(aluMemMux_io_rs2),
    .io_imm(aluMemMux_io_imm),
    .io_out(aluMemMux_io_out)
  );
  PcImmMux immBranchMux ( // @[Core.scala 34:28]
    .io_pcImm(immBranchMux_io_pcImm),
    .io_pcPc4(immBranchMux_io_pcPc4),
    .io_branch(immBranchMux_io_branch),
    .io_out(immBranchMux_io_out)
  );
  ALUBranchMux aluBranchMux ( // @[Core.scala 35:28]
    .io_aluBranch(aluBranchMux_io_aluBranch),
    .io_pc4Branch(aluBranchMux_io_pc4Branch),
    .io_ALUOut(aluBranchMux_io_ALUOut),
    .io_out(aluBranchMux_io_out)
  );
  PcStallMux pcStall ( // @[Core.scala 36:23]
    .io_stall(pcStall_io_stall),
    .io_next(pcStall_io_next),
    .io_current(pcStall_io_current),
    .io_out(pcStall_io_out)
  );
  LoadSelector loadSelector ( // @[Core.scala 37:28]
    .io_func3(loadSelector_io_func3),
    .io_inData(loadSelector_io_inData),
    .io_outData(loadSelector_io_outData)
  );
  assign io_instrAddrs = _io_instrAddrs_T[8:0]; // @[Core.scala 100:43]
  assign io_ALUOut = alu_io_ALUOut; // @[Core.scala 99:13]
  assign io_memWriteData = registerFile_io_readData2; // @[Core.scala 101:48]
  assign io_memWrite = controlUnit_io_memWrite; // @[Core.scala 98:15]
  assign io_storeType = controlUnit_io_storeType; // @[Core.scala 102:16]
  assign controlUnit_io_instr = io_instr; // @[Core.scala 39:24]
  assign controlUnit_io_eq = alu_io_eq; // @[Core.scala 40:21]
  assign controlUnit_io_ge = alu_io_ge; // @[Core.scala 41:21]
  assign controlUnit_io_geu = alu_io_geu; // @[Core.scala 42:22]
  assign controlUnit_io_cpu_wait = io_cpu_wait; // @[Core.scala 44:27]
  assign controlUnit_io_cpu_ready = io_cpu_ready; // @[Core.scala 43:28]
  assign registerFile_clock = clock;
  assign registerFile_reset = reset;
  assign registerFile_io_readAddr1 = io_instr[19:15]; // @[Core.scala 46:40]
  assign registerFile_io_readAddr2 = io_instr[24:20]; // @[Core.scala 47:40]
  assign registerFile_io_writeAddr = io_instr[11:7]; // @[Core.scala 48:40]
  assign registerFile_io_writeData = pcAluMemMux_io_out; // @[Core.scala 49:29]
  assign registerFile_io_writeEn = controlUnit_io_regWrite; // @[Core.scala 50:27]
  assign alu_io_ALUCtrl = controlUnit_io_ALUCtrl; // @[Core.scala 54:18]
  assign alu_io_A = registerFile_io_readData1; // @[Core.scala 52:12]
  assign alu_io_B = rs2ImmMux_io_out; // @[Core.scala 53:12]
  assign immGen_io_in = io_instr; // @[Core.scala 56:16]
  assign immGen_io_format = controlUnit_io_format; // @[Core.scala 57:20]
  assign pc_clock = clock;
  assign pc_reset = reset;
  assign pc_io_inAddr = pcStall_io_out; // @[Core.scala 59:16]
  assign pcIncrementer_io_pc = pc_io_outAddr; // @[Core.scala 61:23]
  assign branchAdder_io_pc = pc_io_outAddr; // @[Core.scala 63:21]
  assign branchAdder_io_imm = immGen_io_out; // @[Core.scala 64:22]
  assign pcAluMemMux_io_pcAluMem = controlUnit_io_pcAluMem; // @[Core.scala 66:27]
  assign pcAluMemMux_io_aluMem = aluMemMux_io_out; // @[Core.scala 68:25]
  assign pcAluMemMux_io_pcImm = pcImmMux_io_out; // @[Core.scala 67:24]
  assign rs2ImmMux_io_rs2Imm = controlUnit_io_rs2Imm; // @[Core.scala 70:23]
  assign rs2ImmMux_io_rs2 = registerFile_io_readData2; // @[Core.scala 72:20]
  assign rs2ImmMux_io_imm = immGen_io_out; // @[Core.scala 71:20]
  assign pcImmMux_io_pcImm = controlUnit_io_pcImm; // @[Core.scala 74:21]
  assign pcImmMux_io_pcPc4 = pcIncrementer_io_outAddr; // @[Core.scala 75:21]
  assign pcImmMux_io_branch = branchAdder_io_outAddr; // @[Core.scala 76:22]
  assign aluMemMux_io_rs2Imm = controlUnit_io_aluMem; // @[Core.scala 78:23]
  assign aluMemMux_io_rs2 = alu_io_ALUOut; // @[Core.scala 79:23]
  assign aluMemMux_io_imm = loadSelector_io_outData; // @[Core.scala 80:28]
  assign immBranchMux_io_pcImm = controlUnit_io_immBranch; // @[Core.scala 82:29]
  assign immBranchMux_io_pcPc4 = pcIncrementer_io_outAddr; // @[Core.scala 84:23]
  assign immBranchMux_io_branch = branchAdder_io_outAddr; // @[Core.scala 83:26]
  assign aluBranchMux_io_aluBranch = controlUnit_io_aluBranch; // @[Core.scala 86:29]
  assign aluBranchMux_io_pc4Branch = immBranchMux_io_out; // @[Core.scala 88:29]
  assign aluBranchMux_io_ALUOut = alu_io_ALUOut; // @[Core.scala 87:26]
  assign pcStall_io_stall = controlUnit_io_stall; // @[Core.scala 90:20]
  assign pcStall_io_next = aluBranchMux_io_out; // @[Core.scala 92:19]
  assign pcStall_io_current = pc_io_outAddr; // @[Core.scala 91:22]
  assign loadSelector_io_func3 = io_instr[14:12]; // @[Core.scala 94:36]
  assign loadSelector_io_inData = io_memReadData; // @[Core.scala 95:26]
endmodule
