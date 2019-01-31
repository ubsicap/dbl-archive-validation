import re
from lxml import etree

from .xhtml import xhtml2string

def process_promotion_section(dom, json_dict):
    promotion_sections = dom.xpath("promotion")
    if len(promotion_sections) > 0:
        promotion_section = promotion_sections[0]
        json_dict["promotion"] = {}
        promo_version_info_elements = promotion_section.xpath("promoVersionInfo")
        if len(promo_version_info_elements) > 0:
            promo_version_info_element = promo_version_info_elements[0]
            json_dict["promotion"]["promoVersionInfo"] = {}
            if "contentType" in promo_version_info_element.attrib:
                json_dict["promotion"]["promoVersionInfo"]["contentType"] = promo_version_info_element.attrib["contentType"]
            json_dict["promotion"]["promoVersionInfo"]["content"] = xhtml2string(promo_version_info_element)
