<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan6" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1" />
        <signal name="XLXN_2(9:0)" />
        <signal name="XLXN_9(7:0)" />
        <signal name="XLXN_10(7:0)" />
        <blockdef name="alu">
            <timestamp>2018-4-26T17:42:28</timestamp>
            <rect width="256" x="64" y="-384" height="384" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
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
        <blockdef name="clk_gen">
            <timestamp>2018-4-26T17:40:37</timestamp>
            <rect width="256" x="64" y="-64" height="64" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="rom">
            <timestamp>2018-4-26T17:41:27</timestamp>
            <rect width="256" x="64" y="-128" height="128" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="mux2">
            <timestamp>2018-4-26T17:42:23</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="mux4">
            <timestamp>2018-4-26T17:42:0</timestamp>
            <rect width="256" x="64" y="-320" height="320" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
        </blockdef>
        <blockdef name="mux8">
            <timestamp>2018-4-26T17:42:17</timestamp>
            <rect width="256" x="64" y="-576" height="576" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-544" y2="-544" x1="320" />
        </blockdef>
        <blockdef name="register_file">
            <timestamp>2018-4-26T17:42:11</timestamp>
            <rect width="256" x="64" y="-576" height="576" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
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
            <rect width="64" x="320" y="-460" height="24" />
            <line x2="384" y1="-448" y2="-448" x1="320" />
            <rect width="64" x="320" y="-364" height="24" />
            <line x2="384" y1="-352" y2="-352" x1="320" />
            <rect width="64" x="320" y="-268" height="24" />
            <line x2="384" y1="-256" y2="-256" x1="320" />
            <rect width="64" x="320" y="-172" height="24" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <rect width="64" x="320" y="-76" height="24" />
            <line x2="384" y1="-64" y2="-64" x1="320" />
        </blockdef>
        <block symbolname="alu" name="XLXI_3">
            <blockpin name="Cin" />
            <blockpin name="uc" />
            <blockpin name="ed" />
            <blockpin name="op(3:0)" />
            <blockpin signalname="XLXN_10(7:0)" name="in1(7:0)" />
            <blockpin signalname="XLXN_9(7:0)" name="in2(7:0)" />
            <blockpin name="Z" />
            <blockpin name="Cout" />
            <blockpin name="V_P" />
            <blockpin name="out1(7:0)" />
        </block>
        <block symbolname="clk_gen" name="XLXI_4">
            <blockpin signalname="XLXN_1" name="clk" />
        </block>
        <block symbolname="rom" name="XLXI_5">
            <blockpin signalname="XLXN_1" name="clk" />
            <blockpin signalname="XLXN_2(9:0)" name="addr(9:0)" />
            <blockpin name="data(15:0)" />
        </block>
        <block symbolname="mux2" name="XLXI_6">
            <blockpin name="ctrl" />
            <blockpin name="in1" />
            <blockpin name="in2" />
            <blockpin signalname="XLXN_9(7:0)" name="out1" />
        </block>
        <block symbolname="mux4" name="XLXI_7">
            <blockpin name="in1" />
            <blockpin name="in2" />
            <blockpin name="in3" />
            <blockpin name="in4" />
            <blockpin name="ctrl(1:0)" />
            <blockpin signalname="XLXN_2(9:0)" name="out1" />
        </block>
        <block symbolname="mux8" name="XLXI_8">
            <blockpin name="in1" />
            <blockpin name="in2" />
            <blockpin name="in3" />
            <blockpin name="in4" />
            <blockpin name="in5" />
            <blockpin name="in6" />
            <blockpin name="in7" />
            <blockpin name="in8" />
            <blockpin name="ctrl(2:0)" />
            <blockpin signalname="XLXN_10(7:0)" name="out1" />
        </block>
        <block symbolname="register_file" name="XLXI_9">
            <blockpin name="clk" />
            <blockpin name="rw" />
            <blockpin name="flctrl" />
            <blockpin name="addro(1:0)" />
            <blockpin name="pcctrl(2:0)" />
            <blockpin name="in1(3:0)" />
            <blockpin name="in2(3:0)" />
            <blockpin name="alu(7:0)" />
            <blockpin name="flags(2:0)" />
            <blockpin name="ro(7:0)" />
            <blockpin name="rd(7:0)" />
            <blockpin name="r13(7:0)" />
            <blockpin name="r14(7:0)" />
            <blockpin name="r15(7:0)" />
            <blockpin name="pc(9:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="400" y="448" name="XLXI_4" orien="R0">
        </instance>
        <instance x="928" y="704" name="XLXI_5" orien="R0">
        </instance>
        <branch name="XLXN_1">
            <wire x2="848" y1="416" y2="416" x1="784" />
            <wire x2="848" y1="416" y2="608" x1="848" />
            <wire x2="928" y1="608" y2="608" x1="848" />
        </branch>
        <branch name="XLXN_2(9:0)">
            <wire x2="912" y1="752" y2="752" x1="784" />
            <wire x2="928" y1="672" y2="672" x1="912" />
            <wire x2="912" y1="672" y2="752" x1="912" />
        </branch>
        <instance x="400" y="1040" name="XLXI_7" orien="R0">
        </instance>
        <instance x="2768" y="1008" name="XLXI_3" orien="R0">
        </instance>
        <instance x="2112" y="560" name="XLXI_6" orien="R0">
        </instance>
        <instance x="2112" y="1296" name="XLXI_8" orien="R0">
        </instance>
        <branch name="XLXN_9(7:0)">
            <wire x2="2624" y1="400" y2="400" x1="2496" />
            <wire x2="2624" y1="400" y2="976" x1="2624" />
            <wire x2="2768" y1="976" y2="976" x1="2624" />
        </branch>
        <instance x="1344" y="1456" name="XLXI_9" orien="R0">
        </instance>
        <branch name="XLXN_10(7:0)">
            <wire x2="2608" y1="752" y2="752" x1="2496" />
            <wire x2="2608" y1="752" y2="912" x1="2608" />
            <wire x2="2768" y1="912" y2="912" x1="2608" />
        </branch>
    </sheet>
</drawing>