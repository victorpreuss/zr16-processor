<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan6" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_155(9:0)" />
        <signal name="RST_N" />
        <signal name="CLK" />
        <signal name="r15(7:5)" />
        <signal name="instruction(15:0)" />
        <signal name="romdata(15:0)" />
        <signal name="XLXN_202(9:0)" />
        <signal name="XLXN_158(7:0)" />
        <signal name="r15(7:0)" />
        <signal name="XLXN_209(3:0)" />
        <signal name="XLXN_210(3:0)" />
        <signal name="XLXN_211(2:0)" />
        <signal name="XLXN_212(2:0)" />
        <signal name="r15(7)" />
        <signal name="r15(2)" />
        <signal name="r15(1)" />
        <signal name="XLXN_225(3:0)" />
        <signal name="XLXN_230(7:0)" />
        <signal name="XLXN_242" />
        <signal name="XLXN_243(2:0)" />
        <signal name="flags(2:0)" />
        <signal name="flags(2)" />
        <signal name="flags(1)" />
        <signal name="flags(0)" />
        <signal name="XLXN_256" />
        <signal name="instruction(7:0)" />
        <signal name="XLXN_245(1:0)" />
        <signal name="instruction(9:8)" />
        <signal name="XLXN_273(1:0)" />
        <signal name="XLXN_257(7:0)" />
        <signal name="XLXN_296(7:0)" />
        <signal name="XLXN_265(7:0)" />
        <signal name="romdata(15:8)" />
        <signal name="romdata(7:0)" />
        <signal name="XLXN_220(7:0)" />
        <signal name="XLXN_348(7:0)" />
        <signal name="XLXN_351" />
        <signal name="XLXN_352" />
        <port polarity="Input" name="RST_N" />
        <port polarity="Input" name="CLK" />
        <blockdef name="alu">
            <timestamp>2018-5-30T16:38:51</timestamp>
            <rect width="256" x="64" y="-384" height="384" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-352" y2="-352" x1="320" />
            <line x2="384" y1="-256" y2="-256" x1="320" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <rect width="64" x="320" y="-76" height="24" />
            <line x2="384" y1="-64" y2="-64" x1="320" />
        </blockdef>
        <blockdef name="mux4">
            <timestamp>2018-5-30T16:52:26</timestamp>
            <rect width="256" x="64" y="-320" height="320" />
            <rect width="64" x="0" y="-300" height="24" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <rect width="64" x="0" y="-236" height="24" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-300" height="24" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
        </blockdef>
        <blockdef name="ram">
            <timestamp>2018-5-30T16:50:34</timestamp>
            <rect width="304" x="64" y="-320" height="320" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="368" y="-300" height="24" />
            <line x2="432" y1="-288" y2="-288" x1="368" />
            <rect width="64" x="368" y="-44" height="24" />
            <line x2="432" y1="-32" y2="-32" x1="368" />
        </blockdef>
        <blockdef name="register_file">
            <timestamp>2018-5-30T16:38:30</timestamp>
            <rect width="256" x="64" y="-640" height="640" />
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <rect width="64" x="0" y="-428" height="24" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <rect width="64" x="0" y="-364" height="24" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <rect width="64" x="0" y="-300" height="24" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <rect width="64" x="0" y="-236" height="24" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-620" height="24" />
            <line x2="384" y1="-608" y2="-608" x1="320" />
            <rect width="64" x="320" y="-524" height="24" />
            <line x2="384" y1="-512" y2="-512" x1="320" />
            <rect width="64" x="320" y="-428" height="24" />
            <line x2="384" y1="-416" y2="-416" x1="320" />
            <rect width="64" x="320" y="-332" height="24" />
            <line x2="384" y1="-320" y2="-320" x1="320" />
            <rect width="64" x="320" y="-236" height="24" />
            <line x2="384" y1="-224" y2="-224" x1="320" />
            <rect width="64" x="320" y="-140" height="24" />
            <line x2="384" y1="-128" y2="-128" x1="320" />
            <rect width="64" x="320" y="-44" height="24" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="rom">
            <timestamp>2018-5-30T16:38:19</timestamp>
            <rect width="256" x="64" y="-64" height="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-44" height="24" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="instruction_register">
            <timestamp>2018-5-30T16:38:41</timestamp>
            <rect width="336" x="64" y="-256" height="256" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="400" y="-236" height="24" />
            <line x2="464" y1="-224" y2="-224" x1="400" />
        </blockdef>
        <blockdef name="control_unit">
            <timestamp>2018-5-30T16:39:6</timestamp>
            <rect width="320" x="64" y="-768" height="768" />
            <line x2="0" y1="-736" y2="-736" x1="64" />
            <line x2="0" y1="-512" y2="-512" x1="64" />
            <rect width="64" x="0" y="-300" height="24" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <rect width="64" x="0" y="-76" height="24" />
            <line x2="0" y1="-64" y2="-64" x1="64" />
            <line x2="448" y1="-736" y2="-736" x1="384" />
            <line x2="448" y1="-672" y2="-672" x1="384" />
            <line x2="448" y1="-608" y2="-608" x1="384" />
            <line x2="448" y1="-544" y2="-544" x1="384" />
            <line x2="448" y1="-480" y2="-480" x1="384" />
            <rect width="64" x="384" y="-428" height="24" />
            <line x2="448" y1="-416" y2="-416" x1="384" />
            <rect width="64" x="384" y="-364" height="24" />
            <line x2="448" y1="-352" y2="-352" x1="384" />
            <rect width="64" x="384" y="-300" height="24" />
            <line x2="448" y1="-288" y2="-288" x1="384" />
            <rect width="64" x="384" y="-236" height="24" />
            <line x2="448" y1="-224" y2="-224" x1="384" />
            <rect width="64" x="384" y="-172" height="24" />
            <line x2="448" y1="-160" y2="-160" x1="384" />
            <rect width="64" x="384" y="-108" height="24" />
            <line x2="448" y1="-96" y2="-96" x1="384" />
            <rect width="64" x="384" y="-44" height="24" />
            <line x2="448" y1="-32" y2="-32" x1="384" />
        </blockdef>
        <blockdef name="mux2">
            <timestamp>2018-5-30T16:38:47</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-172" height="24" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="mux8">
            <timestamp>2018-5-30T16:39:23</timestamp>
            <rect width="256" x="64" y="-576" height="576" />
            <rect width="64" x="0" y="-556" height="24" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <rect width="64" x="0" y="-492" height="24" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <rect width="64" x="0" y="-428" height="24" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <rect width="64" x="0" y="-364" height="24" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <rect width="64" x="0" y="-300" height="24" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <rect width="64" x="0" y="-236" height="24" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-556" height="24" />
            <line x2="384" y1="-544" y2="-544" x1="320" />
        </blockdef>
        <block symbolname="instruction_register" name="XLXI_31">
            <blockpin signalname="CLK" name="clk" />
            <blockpin signalname="RST_N" name="rst_n" />
            <blockpin signalname="XLXN_351" name="en" />
            <blockpin signalname="romdata(15:0)" name="romdata(15:0)" />
            <blockpin signalname="instruction(15:0)" name="instruction(15:0)" />
        </block>
        <block symbolname="control_unit" name="XLXI_32">
            <blockpin signalname="CLK" name="clk" />
            <blockpin signalname="RST_N" name="rst_n" />
            <blockpin signalname="instruction(15:0)" name="instruction(15:0)" />
            <blockpin signalname="r15(7:5)" name="aluflags(2:0)" />
            <blockpin signalname="XLXN_351" name="irctrl" />
            <blockpin signalname="XLXN_242" name="ramrw" />
            <blockpin signalname="XLXN_352" name="regrw" />
            <blockpin signalname="XLXN_225(3:0)" name="aluctrl" />
            <blockpin signalname="XLXN_256" name="aludctrl" />
            <blockpin signalname="XLXN_273(1:0)" name="romctrl(1:0)" />
            <blockpin signalname="XLXN_245(1:0)" name="ramctrl(1:0)" />
            <blockpin signalname="XLXN_211(2:0)" name="pcctrl(2:0)" />
            <blockpin signalname="XLXN_212(2:0)" name="flagsctrl(2:0)" />
            <blockpin signalname="XLXN_243(2:0)" name="aluoctrl(2:0)" />
            <blockpin signalname="XLXN_209(3:0)" name="regorig(3:0)" />
            <blockpin signalname="XLXN_210(3:0)" name="regdest(3:0)" />
        </block>
        <block symbolname="rom" name="XLXI_28">
            <blockpin signalname="XLXN_155(9:0)" name="addr(9:0)" />
            <blockpin signalname="romdata(15:0)" name="data(15:0)" />
        </block>
        <block symbolname="ram" name="XLXI_27">
            <blockpin signalname="CLK" name="clk" />
            <blockpin signalname="RST_N" name="rst_n" />
            <blockpin signalname="XLXN_242" name="rw" />
            <blockpin signalname="XLXN_158(7:0)" name="addr(7:0)" />
            <blockpin signalname="XLXN_230(7:0)" name="datain(7:0)" />
            <blockpin signalname="XLXN_296(7:0)" name="dataout(7:0)" />
            <blockpin name="ramdebug(255:0)" />
        </block>
        <block symbolname="mux2" name="XLXI_50">
            <blockpin signalname="XLXN_256" name="ctrl" />
            <blockpin signalname="XLXN_296(7:0)" name="in1(7:0)" />
            <blockpin signalname="XLXN_257(7:0)" name="in2(7:0)" />
            <blockpin signalname="XLXN_220(7:0)" name="out1(7:0)" />
        </block>
        <block symbolname="mux4" name="XLXI_59">
            <blockpin signalname="XLXN_273(1:0)" name="ctrl(1:0)" />
            <blockpin signalname="XLXN_202(9:0)" name="in1(7:0)" />
            <blockpin name="in2(7:0)" />
            <blockpin name="in3(7:0)" />
            <blockpin name="in4(7:0)" />
            <blockpin signalname="XLXN_155(9:0)" name="out1(7:0)" />
        </block>
        <block symbolname="mux4" name="XLXI_60">
            <blockpin signalname="XLXN_245(1:0)" name="ctrl(1:0)" />
            <blockpin signalname="instruction(7:0)" name="in1(7:0)" />
            <blockpin signalname="XLXN_265(7:0)" name="in2(7:0)" />
            <blockpin signalname="XLXN_257(7:0)" name="in3(7:0)" />
            <blockpin name="in4(7:0)" />
            <blockpin signalname="XLXN_158(7:0)" name="out1(7:0)" />
        </block>
        <block symbolname="mux8" name="XLXI_52">
            <blockpin signalname="XLXN_243(2:0)" name="ctrl(2:0)" />
            <blockpin signalname="instruction(7:0)" name="in1(7:0)" />
            <blockpin signalname="romdata(15:8)" name="in2(7:0)" />
            <blockpin signalname="romdata(7:0)" name="in3(7:0)" />
            <blockpin signalname="XLXN_296(7:0)" name="in4(7:0)" />
            <blockpin signalname="XLXN_265(7:0)" name="in5(7:0)" />
            <blockpin name="in6(7:0)" />
            <blockpin name="in7(7:0)" />
            <blockpin name="in8(7:0)" />
            <blockpin signalname="XLXN_348(7:0)" name="out1(7:0)" />
        </block>
        <block symbolname="alu" name="XLXI_16">
            <blockpin signalname="XLXN_225(3:0)" name="op" />
            <blockpin signalname="r15(7)" name="Cin" />
            <blockpin signalname="r15(2)" name="uc" />
            <blockpin signalname="r15(1)" name="ed" />
            <blockpin signalname="XLXN_348(7:0)" name="in1(7:0)" />
            <blockpin signalname="XLXN_220(7:0)" name="in2(7:0)" />
            <blockpin signalname="flags(2)" name="Z" />
            <blockpin signalname="flags(1)" name="Cout" />
            <blockpin signalname="flags(0)" name="V_P" />
            <blockpin signalname="XLXN_230(7:0)" name="out1(7:0)" />
        </block>
        <block symbolname="register_file" name="XLXI_30">
            <blockpin signalname="CLK" name="clk" />
            <blockpin signalname="RST_N" name="rst_n" />
            <blockpin signalname="XLXN_352" name="rw" />
            <blockpin signalname="instruction(9:8)" name="addro(1:0)" />
            <blockpin signalname="XLXN_211(2:0)" name="pcctrl(2:0)" />
            <blockpin signalname="XLXN_209(3:0)" name="in1(3:0)" />
            <blockpin signalname="XLXN_210(3:0)" name="in2(3:0)" />
            <blockpin signalname="XLXN_230(7:0)" name="alu(7:0)" />
            <blockpin signalname="flags(2:0)" name="flags(2:0)" />
            <blockpin signalname="XLXN_212(2:0)" name="flctrl(2:0)" />
            <blockpin signalname="XLXN_265(7:0)" name="ro(7:0)" />
            <blockpin signalname="XLXN_257(7:0)" name="rd(7:0)" />
            <blockpin name="r13(7:0)" />
            <blockpin name="r14(7:0)" />
            <blockpin signalname="r15(7:0)" name="r15(7:0)" />
            <blockpin signalname="XLXN_202(9:0)" name="pc(9:0)" />
            <blockpin name="regdebug(15:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="7040" height="5440">
        <branch name="XLXN_155(9:0)">
            <wire x2="960" y1="1456" y2="1456" x1="896" />
        </branch>
        <branch name="RST_N">
            <wire x2="2096" y1="368" y2="368" x1="1936" />
        </branch>
        <branch name="CLK">
            <wire x2="2096" y1="144" y2="144" x1="1936" />
        </branch>
        <branch name="r15(7:5)">
            <wire x2="2096" y1="816" y2="816" x1="2016" />
            <wire x2="2016" y1="816" y2="912" x1="2016" />
            <wire x2="2944" y1="912" y2="912" x1="2016" />
            <wire x2="2944" y1="912" y2="1616" x1="2944" />
        </branch>
        <branch name="instruction(15:0)">
            <wire x2="1936" y1="592" y2="592" x1="1920" />
            <wire x2="1936" y1="592" y2="608" x1="1936" />
            <wire x2="1952" y1="608" y2="608" x1="1936" />
            <wire x2="1984" y1="608" y2="608" x1="1952" />
            <wire x2="2000" y1="608" y2="608" x1="1984" />
            <wire x2="2096" y1="592" y2="592" x1="2000" />
            <wire x2="2000" y1="592" y2="608" x1="2000" />
        </branch>
        <branch name="CLK">
            <wire x2="2464" y1="1328" y2="1328" x1="2368" />
        </branch>
        <branch name="r15(7:0)">
            <wire x2="2944" y1="1712" y2="1712" x1="2848" />
            <wire x2="3792" y1="1712" y2="1712" x1="2944" />
            <wire x2="3792" y1="1472" y2="1536" x1="3792" />
            <wire x2="3792" y1="1536" y2="1600" x1="3792" />
            <wire x2="3792" y1="1600" y2="1712" x1="3792" />
        </branch>
        <bustap x2="2944" y1="1712" y2="1616" x1="2944" />
        <branch name="CLK">
            <wire x2="5424" y1="1504" y2="1504" x1="5312" />
        </branch>
        <branch name="RST_N">
            <wire x2="5424" y1="1568" y2="1568" x1="5344" />
        </branch>
        <iomarker fontsize="28" x="2368" y="1328" name="CLK" orien="R180" />
        <branch name="XLXN_209(3:0)">
            <wire x2="2192" y1="1136" y2="1648" x1="2192" />
            <wire x2="2464" y1="1648" y2="1648" x1="2192" />
            <wire x2="2640" y1="1136" y2="1136" x1="2192" />
            <wire x2="2640" y1="784" y2="784" x1="2544" />
            <wire x2="2640" y1="784" y2="1136" x1="2640" />
        </branch>
        <branch name="XLXN_210(3:0)">
            <wire x2="2176" y1="1120" y2="1712" x1="2176" />
            <wire x2="2464" y1="1712" y2="1712" x1="2176" />
            <wire x2="2624" y1="1120" y2="1120" x1="2176" />
            <wire x2="2624" y1="848" y2="848" x1="2544" />
            <wire x2="2624" y1="848" y2="1120" x1="2624" />
        </branch>
        <branch name="XLXN_211(2:0)">
            <wire x2="2208" y1="1152" y2="1584" x1="2208" />
            <wire x2="2464" y1="1584" y2="1584" x1="2208" />
            <wire x2="2656" y1="1152" y2="1152" x1="2208" />
            <wire x2="2656" y1="592" y2="592" x1="2544" />
            <wire x2="2656" y1="592" y2="1152" x1="2656" />
        </branch>
        <branch name="XLXN_212(2:0)">
            <wire x2="2160" y1="1104" y2="1904" x1="2160" />
            <wire x2="2464" y1="1904" y2="1904" x1="2160" />
            <wire x2="2608" y1="1104" y2="1104" x1="2160" />
            <wire x2="2608" y1="656" y2="656" x1="2544" />
            <wire x2="2608" y1="656" y2="1104" x1="2608" />
        </branch>
        <iomarker fontsize="28" x="1936" y="368" name="RST_N" orien="R180" />
        <iomarker fontsize="28" x="1936" y="144" name="CLK" orien="R180" />
        <bustap x2="3888" y1="1472" y2="1472" x1="3792" />
        <branch name="r15(7)">
            <wire x2="4080" y1="1472" y2="1472" x1="3888" />
        </branch>
        <bustap x2="3888" y1="1536" y2="1536" x1="3792" />
        <branch name="r15(2)">
            <wire x2="4080" y1="1536" y2="1536" x1="3888" />
        </branch>
        <bustap x2="3888" y1="1600" y2="1600" x1="3792" />
        <branch name="r15(1)">
            <wire x2="4080" y1="1600" y2="1600" x1="3888" />
        </branch>
        <branch name="XLXN_230(7:0)">
            <wire x2="2464" y1="1776" y2="1776" x1="2416" />
            <wire x2="2416" y1="1776" y2="2160" x1="2416" />
            <wire x2="4560" y1="2160" y2="2160" x1="2416" />
            <wire x2="4560" y1="1696" y2="1696" x1="4464" />
            <wire x2="4560" y1="1696" y2="1760" x1="4560" />
            <wire x2="4560" y1="1760" y2="2160" x1="4560" />
            <wire x2="5424" y1="1760" y2="1760" x1="4560" />
        </branch>
        <iomarker fontsize="28" x="5312" y="1504" name="CLK" orien="R180" />
        <iomarker fontsize="28" x="5344" y="1568" name="RST_N" orien="R180" />
        <instance x="5424" y="1792" name="XLXI_27" orien="R0">
        </instance>
        <branch name="flags(2:0)">
            <wire x2="2320" y1="1840" y2="1840" x1="2272" />
            <wire x2="2368" y1="1840" y2="1840" x1="2320" />
            <wire x2="2464" y1="1840" y2="1840" x1="2368" />
        </branch>
        <bustap x2="2320" y1="1840" y2="1744" x1="2320" />
        <branch name="flags(1)">
            <wire x2="2320" y1="1744" y2="2128" x1="2320" />
            <wire x2="4528" y1="2128" y2="2128" x1="2320" />
            <wire x2="4528" y1="1504" y2="1504" x1="4464" />
            <wire x2="4528" y1="1504" y2="2128" x1="4528" />
        </branch>
        <bustap x2="2368" y1="1840" y2="1744" x1="2368" />
        <bustap x2="2272" y1="1840" y2="1744" x1="2272" />
        <branch name="flags(0)">
            <wire x2="2272" y1="1744" y2="2112" x1="2272" />
            <wire x2="4512" y1="2112" y2="2112" x1="2272" />
            <wire x2="4512" y1="1600" y2="1600" x1="4464" />
            <wire x2="4512" y1="1600" y2="2112" x1="4512" />
        </branch>
        <bustap x2="1952" y1="608" y2="704" x1="1952" />
        <branch name="instruction(7:0)">
            <wire x2="1952" y1="704" y2="976" x1="1952" />
            <wire x2="3280" y1="976" y2="976" x1="1952" />
            <wire x2="4592" y1="976" y2="976" x1="3280" />
            <wire x2="4592" y1="976" y2="1504" x1="4592" />
            <wire x2="4736" y1="1504" y2="1504" x1="4592" />
            <wire x2="3280" y1="976" y2="1200" x1="3280" />
            <wire x2="3408" y1="1200" y2="1200" x1="3280" />
        </branch>
        <branch name="XLXN_245(1:0)">
            <wire x2="4640" y1="528" y2="528" x1="2544" />
            <wire x2="4640" y1="528" y2="1440" x1="4640" />
            <wire x2="4736" y1="1440" y2="1440" x1="4640" />
        </branch>
        <bustap x2="1984" y1="608" y2="704" x1="1984" />
        <branch name="instruction(9:8)">
            <wire x2="1984" y1="704" y2="1520" x1="1984" />
            <wire x2="2464" y1="1520" y2="1520" x1="1984" />
        </branch>
        <branch name="flags(2)">
            <wire x2="2368" y1="1744" y2="2144" x1="2368" />
            <wire x2="4544" y1="2144" y2="2144" x1="2368" />
            <wire x2="4544" y1="1408" y2="1408" x1="4464" />
            <wire x2="4544" y1="1408" y2="2144" x1="4544" />
        </branch>
        <branch name="XLXN_202(9:0)">
            <wire x2="512" y1="1520" y2="1520" x1="464" />
            <wire x2="464" y1="1520" y2="2000" x1="464" />
            <wire x2="2864" y1="2000" y2="2000" x1="464" />
            <wire x2="2864" y1="1808" y2="1808" x1="2848" />
            <wire x2="2864" y1="1808" y2="2000" x1="2864" />
        </branch>
        <branch name="XLXN_273(1:0)">
            <wire x2="2576" y1="16" y2="16" x1="464" />
            <wire x2="2576" y1="16" y2="464" x1="2576" />
            <wire x2="464" y1="16" y2="1456" x1="464" />
            <wire x2="512" y1="1456" y2="1456" x1="464" />
            <wire x2="2576" y1="464" y2="464" x1="2544" />
        </branch>
        <bustap x2="3360" y1="1328" y2="1328" x1="3264" />
        <bustap x2="3360" y1="1264" y2="1264" x1="3264" />
        <branch name="XLXN_296(7:0)">
            <wire x2="3408" y1="1392" y2="1392" x1="3264" />
            <wire x2="3264" y1="1392" y2="1968" x1="3264" />
            <wire x2="3392" y1="1968" y2="1968" x1="3264" />
            <wire x2="3264" y1="1968" y2="2096" x1="3264" />
            <wire x2="5936" y1="2096" y2="2096" x1="3264" />
            <wire x2="5936" y1="1504" y2="1504" x1="5856" />
            <wire x2="5936" y1="1504" y2="2096" x1="5936" />
        </branch>
        <branch name="XLXN_158(7:0)">
            <wire x2="5152" y1="1440" y2="1440" x1="5120" />
            <wire x2="5152" y1="1440" y2="1696" x1="5152" />
            <wire x2="5424" y1="1696" y2="1696" x1="5152" />
        </branch>
        <instance x="960" y="1488" name="XLXI_28" orien="R0">
        </instance>
        <instance x="512" y="1744" name="XLXI_59" orien="R0">
        </instance>
        <branch name="XLXN_242">
            <wire x2="5168" y1="208" y2="208" x1="2544" />
            <wire x2="5168" y1="208" y2="1632" x1="5168" />
            <wire x2="5424" y1="1632" y2="1632" x1="5168" />
        </branch>
        <instance x="4736" y="1728" name="XLXI_60" orien="R0">
        </instance>
        <branch name="XLXN_265(7:0)">
            <wire x2="2992" y1="1328" y2="1328" x1="2848" />
            <wire x2="2992" y1="992" y2="1328" x1="2992" />
            <wire x2="3248" y1="992" y2="992" x1="2992" />
            <wire x2="3248" y1="992" y2="1456" x1="3248" />
            <wire x2="3408" y1="1456" y2="1456" x1="3248" />
            <wire x2="4608" y1="992" y2="992" x1="3248" />
            <wire x2="4608" y1="992" y2="1568" x1="4608" />
            <wire x2="4736" y1="1568" y2="1568" x1="4608" />
        </branch>
        <branch name="romdata(15:8)">
            <wire x2="3408" y1="1264" y2="1264" x1="3360" />
        </branch>
        <branch name="romdata(7:0)">
            <wire x2="3408" y1="1328" y2="1328" x1="3360" />
        </branch>
        <instance x="3408" y="1680" name="XLXI_52" orien="R0">
        </instance>
        <branch name="XLXN_243(2:0)">
            <wire x2="2976" y1="720" y2="720" x1="2544" />
            <wire x2="2976" y1="720" y2="1136" x1="2976" />
            <wire x2="3408" y1="1136" y2="1136" x1="2976" />
        </branch>
        <instance x="3392" y="2064" name="XLXI_50" orien="R0">
        </instance>
        <branch name="XLXN_256">
            <wire x2="3024" y1="400" y2="400" x1="2544" />
            <wire x2="3024" y1="400" y2="1904" x1="3024" />
            <wire x2="3392" y1="1904" y2="1904" x1="3024" />
        </branch>
        <branch name="XLXN_257(7:0)">
            <wire x2="3008" y1="1424" y2="1424" x1="2848" />
            <wire x2="3008" y1="1424" y2="2032" x1="3008" />
            <wire x2="3392" y1="2032" y2="2032" x1="3008" />
            <wire x2="4624" y1="1024" y2="1024" x1="3008" />
            <wire x2="4624" y1="1024" y2="1632" x1="4624" />
            <wire x2="4736" y1="1632" y2="1632" x1="4624" />
            <wire x2="3008" y1="1024" y2="1424" x1="3008" />
        </branch>
        <branch name="romdata(15:0)">
            <wire x2="1424" y1="1456" y2="1456" x1="1344" />
            <wire x2="1456" y1="784" y2="784" x1="1424" />
            <wire x2="1424" y1="784" y2="1008" x1="1424" />
            <wire x2="1424" y1="1008" y2="1456" x1="1424" />
            <wire x2="3264" y1="1008" y2="1008" x1="1424" />
            <wire x2="3264" y1="1008" y2="1264" x1="3264" />
            <wire x2="3264" y1="1264" y2="1328" x1="3264" />
        </branch>
        <branch name="RST_N">
            <wire x2="1456" y1="656" y2="656" x1="1376" />
        </branch>
        <branch name="CLK">
            <wire x2="1456" y1="592" y2="592" x1="1376" />
        </branch>
        <instance x="2096" y="880" name="XLXI_32" orien="R0">
        </instance>
        <instance x="1456" y="816" name="XLXI_31" orien="R0">
        </instance>
        <instance x="4080" y="1760" name="XLXI_16" orien="R0">
        </instance>
        <branch name="XLXN_225(3:0)">
            <wire x2="3856" y1="336" y2="336" x1="2544" />
            <wire x2="3856" y1="336" y2="1408" x1="3856" />
            <wire x2="4080" y1="1408" y2="1408" x1="3856" />
        </branch>
        <branch name="XLXN_220(7:0)">
            <wire x2="4064" y1="1904" y2="1904" x1="3776" />
            <wire x2="4080" y1="1728" y2="1728" x1="4064" />
            <wire x2="4064" y1="1728" y2="1904" x1="4064" />
        </branch>
        <branch name="XLXN_348(7:0)">
            <wire x2="3936" y1="1136" y2="1136" x1="3792" />
            <wire x2="3936" y1="1136" y2="1664" x1="3936" />
            <wire x2="4080" y1="1664" y2="1664" x1="3936" />
        </branch>
        <instance x="2464" y="1936" name="XLXI_30" orien="R0">
        </instance>
        <iomarker fontsize="28" x="1376" y="656" name="RST_N" orien="R180" />
        <iomarker fontsize="28" x="1376" y="592" name="CLK" orien="R180" />
        <branch name="XLXN_351">
            <wire x2="2560" y1="32" y2="32" x1="1424" />
            <wire x2="2560" y1="32" y2="144" x1="2560" />
            <wire x2="1424" y1="32" y2="720" x1="1424" />
            <wire x2="1456" y1="720" y2="720" x1="1424" />
            <wire x2="2560" y1="144" y2="144" x1="2544" />
        </branch>
        <branch name="XLXN_352">
            <wire x2="2224" y1="1168" y2="1456" x1="2224" />
            <wire x2="2464" y1="1456" y2="1456" x1="2224" />
            <wire x2="2672" y1="1168" y2="1168" x1="2224" />
            <wire x2="2672" y1="272" y2="272" x1="2544" />
            <wire x2="2672" y1="272" y2="304" x1="2672" />
            <wire x2="2672" y1="304" y2="1168" x1="2672" />
        </branch>
        <branch name="RST_N">
            <wire x2="2448" y1="1392" y2="1392" x1="2368" />
            <wire x2="2464" y1="1392" y2="1392" x1="2448" />
        </branch>
        <iomarker fontsize="28" x="2368" y="1392" name="RST_N" orien="R180" />
    </sheet>
</drawing>