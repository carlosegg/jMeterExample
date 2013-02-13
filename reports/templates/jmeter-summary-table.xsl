<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:output method="html" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

<xsl:template match="root">
	<html>
		<head>
			<title>JMeter Test Results</title>
			<style type="text/css">
				body {
					font:normal 68% verdana,arial,helvetica;
					color:#000000;
				}
				table tr td, table tr th {
					font-size: 68%;
				}
				table.details tr th{
					font-weight: bold;
					text-align:left;
					background:#a6caf0;
					white-space: nowrap;
				}
				table.details tr td{
					background:#eeeee0;
					white-space: nowrap;
				}
				h1 {
					margin: 0px 0px 5px; font: 165% verdana,arial,helvetica
				}
				h2 {
					margin-top: 1em; margin-bottom: 0.5em; font: bold 125% verdana,arial,helvetica
				}
				h3 {
					margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica
				}
				.Failure {
					font-weight:bold; color:red;
				}
			</style>
		</head>
		<body>
			<xsl:call-template name="resultsList" />
		</body>
	</html>
</xsl:template>

<xsl:template name="resultsList">
	<h2>Resultados de las ejecuciones</h2>
	<table class="details" border="0" cellpadding="5" cellspacing="2" width="95%">
		<tr valign="top">
			<th>Execution Date</th>
			<th>Tests</th>
			<th>Failures</th>
			<th>Success Rate</th>
			<th>Average Time</th>
			<th>Min Time</th>
			<th>Max Time</th>
		</tr>
		<xsl:for-each select="/root/row">
			<tr valign="top">
				<td>
					<xsl:value-of select="elem[@name='Execution Date']" />
				</td>
				<td>
					<xsl:value-of select="elem[@name='Tests']" />
				</td>
				<td>
					<xsl:value-of select="elem[@name='Failures']" />
				</td>
				<td>
					<xsl:value-of select="elem[@name='Success Rate']" />
				</td>
				<td>
					<xsl:value-of select="elem[@name='Min Time']" />
				</td>
				<td>
					<xsl:value-of select="elem[@name='Min Time']" />
				</td>
				<td>
					<xsl:value-of select="elem[@name='Max Time']" />
				</td>
			</tr>
		</xsl:for-each>
	</table>
</xsl:template>


</xsl:stylesheet>