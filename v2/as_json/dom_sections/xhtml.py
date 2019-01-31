import re


from lxml import etree


def xhtml2string(element):
    """
    Expects xhtml nested elements enclosed by a wrapper element (which will not be serialized).
    """
    string = etree.tostring(element).decode()
    string = re.sub("</?{0}[^>]*>".format(element.tag), "", string)
    return re.sub(" +", " ", string)
