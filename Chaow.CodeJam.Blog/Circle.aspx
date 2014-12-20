<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Circle.aspx.cs" Inherits="Chaow.CodeJam.Blog.Circle" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <style type="text/css">
            .auto-style1 {
                text-align: right;
            }
            .auto-style2 {
                text-align: center;
            }
            .auto-style3 {
                font-weight: bold;
                text-align: center;
            }
        </style>
    
        โจทย์ข้อนี้ให้หาจำนวนรูปแบบของวงกลม <a href="http://mathworld.wolfram.com/HamiltonianCycle.html">Hamiltonion Cycle</a><br />
        สมมติ วงกลมเรียงตามจุดหมายเลข 1-2-3-4-5 (และต่อจาก 5 คือ 1 ใหม่)<br />
        กับวงกลมตามหมายเลข 2-3-4-5-1 เป็นวงกลมชุดเดียวกัน เพราะเรียงเหมือนวงกลมแรก แค่เริ่มจาก 2 เท่านั้นเอง<br />
        และวงกลม 5-4-3-2-1 ก็ถือเป็นวงกลมชุดเดียวกัน เพราะไม่ว่าจะเรียงจากหน้าไปหลัง หรือหลังไปหน้า ก็เรียงเหมือนกัน<br />
        แต่กับวงกลม 1-3-2-4-5 ถือเป็นวงกลมคนละชุด เพราะเรียงไม่เหมือนกัน<br />
        <br />
        ยังไม่จบ โจทย์มีข้อห้ามให้บางจุด ไม่สามารถเชื่อมกัน<br />
        เช่น ห้าม 3-5<br />
        เราไม่สามารถสร้างรูปแบบ 1-2-3-5-4 ได้<br />
        โจทย์จะให้จำนวนของจุด และจุดที่ห้ามเชื่อมกัน แล้วให้หาจำนวนชุดของวงกลมทั้งหมด<br />
        โดยคำตอบต้อง modulo กับ 99010<br />
        อ่านเพิ่มเติม <a href="https://code.google.com/codejam/contest/32004/dashboard#s=p2">ที่นี่</a><br />
        <br />
        เนื่องจากเรามี constraint ที่ห้ามบางจุดเชื่อมกัน เราจึงไม่สามารถใช้ factorial คำนวนได้<br />
        แต่ถ้าเรา loop ทดลองทีละวิธี วิธีนี้อาจจะมีความซับซ้อนถึง O(n!) (n สามารถมีค่าถึง 300)<br />
        แต่โจทย์บอกว่า จุดที่ห้ามเชื่อมกันจะมีไม่เกิน 15 ชุด<br />
        ดังนั้น เราอาจใช้ factorial หาจำนวนวิธีการเรียงของวงกลม ทำให้ได้จำนวนรูปแบบของวงกลมทั้งหมด<br />
        แล้วค่อยหาจำนวนรูปแบบที่มีจุดที่ห้ามเชื่อมกัน แล้วเอามาลบกัน<br />
        <br />
        เริ่มจาก class ช่วยก่อน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">type</span>&nbsp;<span style="color:#4ec9b0;">EdgeString</span>&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;{&nbsp;terminal<span style="color:#b4b4b4;">:</span><span style="color:#4ec9b0;">string</span>&nbsp;<span style="color:#4ec9b0;">Set</span>;&nbsp;connections<span style="color:#b4b4b4;">:</span><span style="color:#4ec9b0;">string</span>&nbsp;<span style="color:#4ec9b0;">Set</span>&nbsp;}
<span style="color:#569cd6;">module</span>&nbsp;<span style="color:#4ec9b0;">Edge</span>&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;TryJoin&nbsp;b&nbsp;a&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;conn&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>intersect&nbsp;a<span style="color:#b4b4b4;">.</span>terminal&nbsp;b<span style="color:#b4b4b4;">.</span>terminal
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;conn&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>empty
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;None
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;Some({&nbsp;terminal&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;a<span style="color:#b4b4b4;">.</span>terminal&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;b<span style="color:#b4b4b4;">.</span>terminal&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;conn;&nbsp;
                    connections&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;a<span style="color:#b4b4b4;">.</span>connections&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;b<span style="color:#b4b4b4;">.</span>connections&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;conn&nbsp;})</pre>
        เหตุผลที่มี class นี้เพราะ เราจะเอาไว้หาจุดเชื่อม<br />
        เช่น EdgeString 1-2-3 terminal คือปลายของเส้น คือ 1;3 ส่วน connections คือจุดกลางของเส้น คือ 2<br />
        คำสั่ง TryJoin คือลองเชื่อม EdgeString 2 เส้นดู เช่น 1-2-3 เชื่อมกับ 3-4-5 จะกลายเป็น 1-2-3-4-5<br />
        <br />
        ถัดมา อีกคำสั่งที่จำเป็นเลย คือ factorial<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;fac&nbsp;n&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;n&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;n&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;fac&nbsp;(n<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>)&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">99010</span></pre>
        เราสามารถ % 99010 ได้เลย เพราะโจทย์กำหนด มิเช่นนั้นอาจจะ overflow<br />
        <br />
        เริ่ม solve กันเลย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;len&nbsp;set&nbsp;<span style="color:#b4b4b4;">=</span></pre>
        len คือ จำนวนจุด<br />
        set คือ set ของจุดที่ห้ามเชื่อมกัน<br />
        <br />
        ถัดมาคือ หาวิธีเรียงทั้งหมด<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;allCount&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;fac&nbsp;(len<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">2</span></pre>
        สมมติ จำนวนจุดทั้งหมดคือ 5<br />
        วิธีการเรียงทั้งหมดคือ (n-1)!/2<br />
        n-1 เพราะตามหลักด้านบน 1-2-3-4-5 และ 2-3-4-5-1 คือวงกลมเดียวกัน<br />
        และ /2 เพราะตามหลักด้านบนเช่นเดียวกัน 1-2-3-4-5 และ 5-4-3-2-1 คือวงกลมเดียวกัน<br />
        ดังนั้น รูปแบบวงกลมทั้งหมดมี
        <br />
        (5-1)!/2 = 12 รูปแบบ<br />
        <br />
        ถัดมาเป็นคำสั่งยาวหน่อย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;combin&nbsp;id&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">function</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>singleton&nbsp;<span style="color:#4ec9b0;">List</span><span style="color:#b4b4b4;">.</span>empty
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;cnt&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;collectFn&nbsp;i&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;edge&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>get&nbsp;set&nbsp;i
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;Validate&nbsp;it&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>intersect&nbsp;it<span style="color:#b4b4b4;">.</span>connections&nbsp;edge<span style="color:#b4b4b4;">.</span>terminal&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>empty&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>count&nbsp;it<span style="color:#b4b4b4;">.</span>connections&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;len<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">2</span>&nbsp;<span style="color:#b4b4b4;">||</span>&nbsp;it<span style="color:#b4b4b4;">.</span>terminal&nbsp;<span style="color:#b4b4b4;">&lt;&gt;</span>&nbsp;edge<span style="color:#b4b4b4;">.</span>terminal)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;edges&nbsp;<span style="color:#569cd6;">in</span>&nbsp;combin&nbsp;(i<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">1</span>)&nbsp;(cnt<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>)&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>forall&nbsp;Validate&nbsp;edges&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;foldFn&nbsp;(edge,list)&nbsp;it&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;<span style="color:#4ec9b0;">Edge</span><span style="color:#b4b4b4;">.</span>TryJoin&nbsp;edge&nbsp;it&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;None&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;edge,it::list
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Some(newEdge)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;newEdge,list
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newEdge,list&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>fold&nbsp;foldFn&nbsp;(edge,<span style="color:#4ec9b0;">List</span><span style="color:#b4b4b4;">.</span>empty)&nbsp;edges
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;newEdge::list
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;finish&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>length&nbsp;set&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;cnt
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>collect&nbsp;collectFn&nbsp;{id<span style="color:#b4b4b4;">..</span>finish}</pre>
        คำสั่งยาว แต่ไม่มีอะไรมาก มันคือคำสั่งลองเชื่อมจุดแบบต่างๆ ดู<br />
        เช่น ถ้ามี 1-2, 2-3, และ 3-4<br />
        มันก็จะได้ [1-2-3] [1-2;3-4] [2-3-4]<br />
        <br />
        ถัดมา อันนี้ซับซ้อนนิดนึง<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;forbidCount&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;sumFn&nbsp;i&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;sign&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">if</span>&nbsp;i&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">2</span>&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">else</span>&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;allCount&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;fac&nbsp;(len<span style="color:#b4b4b4;">-</span>i<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>)&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">9901</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;sumFnX&nbsp;edges&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;len&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">List</span><span style="color:#b4b4b4;">.</span>length&nbsp;edges
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>fold&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;last&nbsp;i&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;last&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;<span style="color:#b5cea8;">2</span>&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">9901</span>)&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;{<span style="color:#b5cea8;">2..</span>len}&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">9901</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;combCount&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;combin&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;i&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sumBy&nbsp;sumFnX
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sign&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;allCount&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;combCount&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">9901</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;maxCombo&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;min&nbsp;(<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>length&nbsp;set)&nbsp;len
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sumBy&nbsp;sumFn&nbsp;{<span style="color:#b5cea8;">1..</span>maxCombo}&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">9901</span></pre>
        คำสั่งชุดนี้ ไว้หาว่า รูปแบบวงกลมที่มีจุดที่ห้ามเชื่อมกัน มีกี่รูปแบบ<br />
        คำสั่งนี้ ใช้หลักการ <a href="http://mathworld.wolfram.com/Inclusion-ExclusionPrinciple.html">Inclusion-Exclusion Principle</a><br />
        เช่น ถ้าห้าม 1-2, 2-3 และ 3-4<br />
        จะมี set ทั้งหมด 7 set คือ [1-2] [2-3] [3-4] [1-2-3] [1-2;3-4] [2-3-4] [1-2-3-4]<br />
        ถ้าเข้าตามสูตรด้านบนจะได้ดังนี้<br />
        <br />
        <table><tr><td class="auto-style3" style="border-style: solid; border-width: 1px">จำนวน Union </td><td class="auto-style3" style="border-style: solid; border-width: 1px">Set</td><td class="auto-style3" style="border-style: solid; border-width: 1px">จำนวนรูปแบบทั้งหมด</td></tr><tr><td class="auto-style2" rowspan="3" style="border-style: solid; border-width: 1px">1</td><td style="border-style: solid; border-width: 1px">[1-2]</td><td class="auto-style1" style="border-style: solid; border-width: 1px">6</td></tr><tr><td style="border-style: solid; border-width: 1px">[2-3]</td><td class="auto-style1" style="border-style: solid; border-width: 1px">6</td></tr><tr><td style="border-style: solid; border-width: 1px">[3-4]</td><td class="auto-style1" style="border-style: solid; border-width: 1px">6</td></tr><tr><td class="auto-style2" rowspan="3" style="border-style: solid; border-width: 1px">2</td><td style="border-style: solid; border-width: 1px">[1-2-3]</td><td class="auto-style1" style="border-style: solid; border-width: 1px">-2</td></tr><tr><td style="border-style: solid; border-width: 1px">[1-2;3-4]</td><td class="auto-style1" style="border-style: solid; border-width: 1px">-4</td></tr><tr><td style="border-style: solid; border-width: 1px">[2-3-4]</td><td class="auto-style1" style="border-style: solid; border-width: 1px">-2</td></tr><tr><td class="auto-style2" style="border-style: solid; border-width: 1px">3</td><td style="border-style: solid; border-width: 1px">[1-2-3-4]</td><td class="auto-style1" style="border-style: solid; border-width: 1px">1</td></tr></table>
        <br />
        รวมกัน แบบที่มีจุดที่ห้ามเชื่อมกันทั้งหมด คือ 11 รูปแบบ<br />
        สุดท้ายเอามาหักลบกัน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;count&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;allCount&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;forbidCount
string&nbsp;((count<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">9901</span>)&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">9901</span>)</pre>
        เช่น จากด้านบน ถ้าจำนวนจุดคือ 5 และห้าม 1-2, 2-3, และ 3-4<br />
        allCount คือ 12<br />
        forbitCount คือ 11<br />
        คำตอบคือ 1 (เส้น 1-3-5-2-4)<br />
        <br />
        จบ</div>
    </form>
</body>
</html>
