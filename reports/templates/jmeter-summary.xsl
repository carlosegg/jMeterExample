<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:output method="text" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

<xsl:template match="testResults">
	<xsl:call-template name="summary" />
</xsl:template>

<xsl:template name="summary">
	<xsl:variable name="allCount" select="count(/testResults/*)" />
	<xsl:variable name="allFailureCount" select="count(/testResults/*[attribute::s='false'])" />
	<xsl:variable name="allSuccessCount" select="count(/testResults/*[attribute::s='true'])" />
	<xsl:variable name="allSuccessPercent" select="$allSuccessCount div $allCount" />
	<xsl:variable name="allTotalTime" select="sum(/testResults/*/@t)" />
	<xsl:variable name="allAverageTime" select="$allTotalTime div $allCount" />
	<xsl:variable name="allMinTime">
		<xsl:call-template name="min">
			<xsl:with-param name="nodes" select="/testResults/*/@t" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="allMaxTime">
		<xsl:call-template name="max">
			<xsl:with-param name="nodes" select="/testResults/*/@t" />
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="lastStamp" select="/testResults/*[last()]/@ts" />
	<xsl:variable name="lastDate" select='xs:dateTime("1970-01-01T00:00:00") + $lastStamp * xs:dayTimeDuration("PT0.001S")' />


	<xsl:value-of select="format-dateTime($lastDate,'[Y,4]-[M,2]-[D,2] [H,2]:[m,2]:[s,2]')"/>,<xsl:value-of select="$allCount" />,<xsl:value-of select="$allFailureCount" />,<xsl:value-of select="$allSuccessPercent" />,<xsl:value-of select="$allAverageTime" />,<xsl:value-of select="$allMinTime" />,<xsl:value-of select="$allMaxTime" />
</xsl:template>

<xsl:template name="min">
	<xsl:param name="nodes" select="/.." />
	<xsl:choose>
		<xsl:when test="not($nodes)">NaN</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$nodes">
				<xsl:sort data-type="number" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="number(.)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="max">
	<xsl:param name="nodes" select="/.." />
	<xsl:choose>
		<xsl:when test="not($nodes)">NaN</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="$nodes">
				<xsl:sort data-type="number" order="descending" />
				<xsl:if test="position() = 1">
					<xsl:value-of select="number(.)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>