<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MinimumScalarProduct.aspx.cs" Inherits="Chaow.CodeJam.Blog.MinimumScalarProduct" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อนี้โจทย์ให้จับคู่ vector<br />
        แล้วให้เอาแต่ละจุดของ vector มาคูณกัน<br />
        โดยต้องได้ผลรวมที่น้อยที่สุด<br />
        อ่านต่อ <a href="https://code.google.com/codejam/contest/32016/dashboard">ที่นี่</a><br />
        <br />
        วิธีคิดก็ง่ายมาก ก็ให้ vector นึงเรียงจากน้อยไปมาก<br />
        อีก vector ก็เรียงมากไปน้อยแล้วคูณกันก็จบ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;seq1&nbsp;seq2&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;seq1&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;seq1&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sort
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;seq2&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;seq2&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sortBy&nbsp;(<span style="color:#b4b4b4;">~-</span>)&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#57a64a;">//&nbsp;Unary&nbsp;minus</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>zip&nbsp;seq1&nbsp;seq2&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(a,&nbsp;b)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;int64&nbsp;a&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;int64&nbsp;b)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sum
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;string</pre>
        ใน f# การประกาศทับตัวแปรเดิมเค้าเรียกว่า <a href="http://msdn.microsoft.com/en-us/library/dd233229.aspx">shadowing</a><br />
        เช่น let seq1 = seq1 |&gt; Seq.sort<br />
        จริงๆ ก็เหมือน imparative แต่ shadowing จะพิเศษกว่าตรงที่ ตัวแปลแรกกับตัวแปรหลังไม่เกี่ยวข้องกันเลย<br />
        เช่น เราสามารถเปลี่ยน type ของตัวแปรก็ได้<br />
        <br />
        และใน f# เราไม่มี sort descending เลยต้อง sortBy negative แทน<br />
        อีกอย่างคือ <a href="http://msdn.microsoft.com/en-us/library/dd233228.aspx">operator</a> ของ f# จะไม่ซ้ำกันเลย ดังนั้น minus กับ unary minus มี symbol ต่างกัน<br />
        <br />
        ส่วน zip คือ จับคู่ item ใน list<br />
        แล้วเราก็เอามาคูณกัน แล้วก็หาผลรวม<br />
        <br />
        จบ</div>
    </form>
</body>
</html>
