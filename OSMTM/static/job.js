var map = new OpenLayers.Map('map', {
    controls: []
});
var osm = new OpenLayers.Layer.OSM();
map.addLayer(osm);
var layer = new OpenLayers.Layer.Vector("Objects", {
    style: {
        strokeColor: "blue",
        strokeWidth: 3,
        strokeOpacity: 0.5,
        fillOpacity: 0.2,
        fillColor: "lightblue",
        pointRadius: 6
    },
    projection: new OpenLayers.Projection("EPSG:4326"),
    displayInLayerSwitcher: false
});

map.addLayer(layer);

var colors = ["#aaa", "red", "green"];
var context = {
    getColor: function(feature) {
        checkin = feature.attributes.checkin || 0;
        return colors[checkin];
    },
    getStrokeColor: function(feature) {
        return (feature.attributes.checkout &&
                feature.attributes.checkout !== null) ?
            "orange" : "black";
    },
    getStrokeWidth: function(feature) {
        return (feature.attributes.checkout &&
                feature.attributes.checkout !== null) ?
            1.5 : 0.3;
    }
};
var template = {
    fillColor: "${getColor}",
    fillOpacity: 0.5,
    strokeColor: "${getStrokeColor}",
    strokeWidth: "${getStrokeWidth}",
    strokeOpacity: 0.5
};
var style = new OpenLayers.Style(template, {context: context});
var tilesLayer = new OpenLayers.Layer.Vector("Tiles Layers", {
    styleMap: new OpenLayers.StyleMap(style),
    renderers: ['Canvas']
});
map.addLayer(tilesLayer);

function showTilesStatus() {
    var protocol = new OpenLayers.Protocol.HTTP({
        url: tiles_status_url,
        format: new OpenLayers.Format.JSON(),
        callback: function(response) {
            if (response.success()) {
                $.each(tilesLayer.features, function(index, feature) {
                    feature.attributes = {};
                });
                $.each(response.features, function(id, val) {
                    var feature = tilesLayer.getFeatureByFid(id);
                    feature.attributes = val;
                });
                tilesLayer.redraw();
            }
        }
    });
    protocol.read();
}

var protocol = new OpenLayers.Protocol.HTTP({
    url: job_url,
    format: new OpenLayers.Format.GeoJSON(),
    callback: function(response) {
        if (response.success()) {
            layer.addFeatures(response.features);
            map.zoomToExtent(layer.getDataExtent());
        }
    }
});
protocol.read();

protocol = new OpenLayers.Protocol.HTTP({
    url: tiles_url,
    format: new OpenLayers.Format.GeoJSON(),
    callback: function(response) {
        if (response.success()) {
            tilesLayer.addFeatures(response.features);
            map.zoomToExtent(tilesLayer.getDataExtent());
            showTilesStatus();
        }
    }
});
protocol.read();


$('form').live('submit', function(e) {
    var formData = $(this).serializeObject();
    var submitName = $("button[type=submit][clicked=true]").attr("name");
    formData[submitName] = true;
    $.ajax({
        url: this.action,
        type: "POST",
        data: formData,
        success: function(responseText){
            $('#task').html(responseText);
            showTilesStatus();
        },
        failure: function() {
            alert("error");
        }
    });
    return false;
});
$("form button[type=submit]").live('click', function() {
    $("button[type=submit]", $(this).parents("form")).removeAttr("clicked");
    $(this).attr("clicked", "true");
});
$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};
