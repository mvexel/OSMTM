<%inherit file="/base.mako"/>
<%def name="id()">job</%def>
<%def name="title()">Job - ${job.title}</%def>
<div class="content group wrap">
    <section class="job">
        <h1>Job: ${job.title}</h1>
        <h3>Description</h3>
        <p>${job.description|n}</p>
        <h3>Workflow</h3>
        <p>${job.workflow|n}</p>
        <hr />
    </section>
    <section class="map">
        <div id="map"></div>
        <div id="stats">
            <ul class="legend">
                <li><div class=""></div>Total (${len(job.tiles)})</li>
                <li><div class="checkin1"></div>Done (${len([x for x in job.tiles if x.checkin == 1])})</li>
                <li><div class="checkin2"></div>Validated (${len([x for x in job.tiles if x.checkin == 2])})</li>
                <li><div class="checkout"></div>Curr. worked on (${len([x for x in job.tiles if x.checkout != None])})</li>
            </ul>
        </div>
    </section>
    <section class="task">
        <div id="task">
            <%include file="/task.mako" />
        </div>
    </section>
</div>
<script type="text/javascript" src="${request.static_url('OSMTM:static/OpenLayers.js')}"></script>
<script type="text/javascript">
    var id = ${job.id};
    var job_url = "${request.route_url('job_geom', id=job.id)}";
    var tiles_url = "${request.route_url('tiles', id=job.id)}";
</script>
<script type="text/javascript" src="${request.static_url('OSMTM:static/Div.js')}"></script>
<script type="text/javascript" src="${request.static_url('OSMTM:static/Static.js')}"></script>
<script type="text/javascript" src="${request.static_url('OSMTM:static/job.js')}"></script>
