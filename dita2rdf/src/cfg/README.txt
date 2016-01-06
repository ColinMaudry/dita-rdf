## DITA RDF customization

Two aspects of the DITA RDF plugin can be customized:
- the configuration
- the XSL processing

Feel free to contact me at colin@maudry.com if you need any help.

### Configuration

The default configuration is only good for demonstration and testing purposes. I highly recommend you customize the configuration as soon as possible in order to get familiar with the notions of URIs.

Steps to customize the configuration:

1. The plugin must be installed in your DITA OT
2. In /plugin/com.github.colinmaudry.dita2rdf/customization, copy catalog.xml.orig
3. Rename it catalog.xml
3. In catalog.xml, uncomment <uri name="cfg:rdf/config.xml" uri="rdf/config.xml"/>
4. In /plugin/com.github.colinmaudry.dita2rdf/customization/rdf/config.xml, follow the instructions to edit the configuration
5. Save

Your customized configuration now replaces the default one.

### XSL processing

TODO


