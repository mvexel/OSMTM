% if not tile:
    <div>
        <form action="${request.route_url('task_take', job=job.id)}">
            <input type="submit" value="Take a task randomly"/>
        </form>
    </div>
% else:
    <h1>Task: ${tile.x} / ${tile.y}</h1>
    <div id="export">
        Open with <a href="javascript:void(0);" id="josm">JOSM</a>, 
        <a href="javascript:void(0);" id="potlatch">Potlatch</a>, 
        <a href="javascript:void(0);" id="potlatch2">Potlatch 2</a>, 
        <a href="javascript:void(0);" id="wp">Walking Papers</a>
    </div>
    <br />
    <div> 
        % if tile.checkout:
            <form action="${request.route_url('task_done', job=tile.job_id, x=tile.x, y=tile.y)}">
            % if user.role == 1:
                <p>
                Now you can edit the elements in this area.
                Once the task is done, come back here and then mark it as done.
                Don't forget to leave a comment.
                </p>
            % else:
                <p>Please review the task and give it a thumb up or send it back to the queue.</p>
            % endif
                <div class="field">
                <label for="task_comment">Comment</label>
                <textarea id="task_comment" name="comment"></textarea>
                </div>
            % if user.role == 1:
                <div class="field">
                <input type="submit" value="Mark task as done"/>
                </div>
            % else:
                <div class="field">
                <button type="submit" value="Validate" class="thumbup">
                    <img src="${request.static_url('OSMTM:static/thumb-up.png')}" />
                    Validate
                </button>
                <button type="submit" value="Invalidate" name="invalidate" class="thumbdown">
                    <img src="${request.static_url('OSMTM:static/thumb.png')}" />
                    Invalidate
                </button>
                </div>
            % endif 
            <div class="clear"></div>
            <p>
            Can't work on this task right now? No problem.
            <a href="${request.route_url('task_unlock', job=tile.job_id, x=tile.x, y=tile.y)}">Unlock it!</a>
            </p>
            </form>
        % endif
    </div>
    <script type="text/javascript">
        <%
            from geojson import dumps
            feature = dumps(tile.to_polygon())
        %>
        var tiles = ${feature|n};
    </script>
% endif
