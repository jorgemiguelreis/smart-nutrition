<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output indent="yes"/>
    <xsl:output omit-xml-declaration="yes"/>
    <xsl:template match="report">
        <xsl:apply-templates select="food"></xsl:apply-templates>
    </xsl:template>
        
    <xsl:template match="food">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>

    
</xsl:stylesheet>