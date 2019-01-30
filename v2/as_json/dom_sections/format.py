from ..metadata_as_json_exception import MetadataAsJsonException


def process_format_section(dom, json_dict, medium):
    if medium is None:
        return
    format_sections = dom.xpath("format")
    if len(format_sections) > 0:
        format_section = format_sections[0]
        json_dict["format"] = {}
        if medium == "text":
            process_text_format_section(format_section, json_dict["format"])
        elif medium == "audio":
            process_audio_format_section(format_section, json_dict["format"])
        elif medium == "video":
            process_video_format_section(format_section, json_dict["format"])
        elif medium == "print":
            process_print_format_section(format_section, json_dict["format"])
        elif medium == "braille":
            process_braille_format_section(format_section, json_dict["format"])
        else:
            raise MetadataAsJsonException("Unknown medium type '{0}'".format(medium))


def process_text_format_section(dom, json_dict):
    for bool_field in [
        "versedParagraphs"
    ]:
        field_nodes = dom.xpath(bool_field)
        if len(field_nodes) > 0:
            json_dict[bool_field] = field_nodes[0].text == "true"


def process_audio_format_section(dom, json_dict):
    for string_field in [
        "compression",
        "trackConfiguration"
    ]:
        field_nodes = dom.xpath(string_field)
        if len(field_nodes) > 0:
            json_dict[string_field] = str(field_nodes[0].text)
    for int_field in [
        "bitRate",
        "bitDepth",
        "samplingRate"
    ]:
        field_nodes = dom.xpath(int_field)
        if len(field_nodes) > 0:
            json_dict[int_field] = int(field_nodes[0].text)


def process_video_format_section(dom, json_dict):
    for string_field in [
        "container"
    ]:
        field_nodes = dom.xpath(string_field)
        if len(field_nodes) > 0:
            json_dict[string_field] = str(field_nodes[0].text)
    process_video_video_stream(dom, json_dict)
    process_video_audio_stream(dom, json_dict)
    process_video_subtitle_stream(dom, json_dict)


def process_video_video_stream(dom, json_dict):
    video_stream_elements = dom.xpath("videoStream")
    if len(video_stream_elements) > 0:
        video_stream_element = video_stream_elements[0]
        json_dict["videoStream"] = {}
        for string_field in [
            "codec",
            "screenResolution"
        ]:
            field_nodes = video_stream_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["videoStream"][string_field] = str(field_nodes[0].text)
        for int_field in [
            "bitRate"
        ]:
            field_nodes = video_stream_element.xpath(int_field)
            if len(field_nodes) > 0:
                json_dict["videoStream"][int_field] = int(field_nodes[0].text)
        for float_field in [
            "frameRate"
        ]:
            field_nodes = video_stream_element.xpath(float_field)
            if len(field_nodes) > 0:
                json_dict["videoStream"][float_field] = float(field_nodes[0].text)



def process_video_audio_stream(dom, json_dict):
    audio_stream_elements = dom.xpath("audioStream")
    if len(audio_stream_elements) > 0:
        audio_stream_element = audio_stream_elements[0]
        json_dict["audioStream"] = {}
        process_audio_format_section(audio_stream_element, json_dict["audioStream"])


def process_video_subtitle_stream(dom, json_dict):
    subtitle_stream_elements = dom.xpath("subtitleStream")
    if len(subtitle_stream_elements) > 0:
        subtitle_stream_element = subtitle_stream_elements[0]
        json_dict["subtitleStream"] = {}



def process_print_format_section(dom, json_dict):
    for string_field in [
        "width",
        "height",
        "scale",
        "orientation",
        "color"
    ]:
        field_nodes = dom.xpath(string_field)
        if len(field_nodes) > 0:
            json_dict[string_field] = str(field_nodes[0].text)
    for int_field in [
        "pageCount"
    ]:
        field_nodes = dom.xpath(int_field)
        if len(field_nodes) > 0:
            json_dict[int_field] = int(field_nodes[0].text)
    for bool_field in [
        "pod"
    ]:
        field_nodes = dom.xpath(bool_field)
        if len(field_nodes) > 0:
            json_dict[bool_field] = field_nodes[0].text == "true"
    process_print_fonts(dom, json_dict)
    process_print_edgespace(dom, json_dict)


def process_print_fonts(dom, json_dict):
    fonts_elements = dom.xpath("fonts")
    if len(fonts_elements) > 0:
        fonts_element = fonts_elements[0]
        json_dict["fonts"] = []
        for font in fonts_element.xpath("font"):
            font_record = {}
            if "type" in font.attrib:
                font_record["type"] = font.attrib["type"]
            if font.text:
                font_record["name"] = font.text
            if len(font_record) > 0:
                json_dict["fonts"] += [font_record]


def process_print_edgespace(dom, json_dict):
    edgespace_elements = dom.xpath("edgeSpace")
    if len(edgespace_elements) > 0:
        edgespace_element = edgespace_elements[0]
        json_dict["edgeSpace"] = {}
        for string_field in [
            "top",
            "bottom",
            "inside",
            "outside"
        ]:
            field_nodes = edgespace_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["edgeSpace"][string_field] = str(field_nodes[0].text)


def process_braille_format_section(dom, json_dict):
    pass
