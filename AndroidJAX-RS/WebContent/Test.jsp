<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script>

var db;
var areaId = null;
var reportId = null;
var paths = null;

function showList()
{
	document.getElementById("reportList").style.display = "";
	document.getElementById("reportEditor").style.display = "none";
	
	updateReports();
}

function showEditor()
{
	document.getElementById("reportList").style.display = "none";
	document.getElementById("reportEditor").style.display = "";
	
	reportId = this.tagId;
	//updateAreas();
	updateEditor();
	updateFiles();
}

function save()
{
	var text = document.getElementById("textEditor").value;
	var name = document.getElementById("reportName").value;

	if (!name || name == "" || !text || text == "")
	{
		alert("Input data is not correct.")
		return;
	}
	
	if (!reportId)
	{
		db.transaction(
		function(q)
		{
			q.executeSql("insert into report (area_id, name, report_text) values(?, ?, ?)", [areaId, name, text], null,
			function() { alert("Can not insert new report."); }
			);
		});
	}
	else
	{
		db.transaction(
		function(q)
		{
			q.executeSql("update report set name = ?, report_text = ? where report_id = ?", [name, text, reportId], null,
			function() { alert("Can not update report."); }
			);
		});
	}
	
	var isExist;
	var pathsForAdd = new Array();
	var index = 0;
	var divFiles = document.getElementById("files");
	
	for (var i = 0; i < divFiles.childNodes.length; i++)
	{
		isExist = false;
		
		for (var j = 0; j < paths.length; j++)
		{
			if (divFiles.childNodes[i].src == paths[j])
			{
				isExist = true;
				break;
			}
		}
		
		if(!isExist)
		{
			pathsForAdd[index++] = divFiles.childNodes[i].src;
		}
	}
	
	if (pathsForAdd.length > 0)
	{
		var query = "insert into file_path (report_id, value) select " + reportId + ", '" + pathsForAdd[0] + "'";
		
		for (var i = 1; i < pathsForAdd.length; i++)
		{
			query += " union all select " + reportId + ", '" + pathsForAdd[i] + "'";
		}
		
		//alert(query);
		
		db.transaction(
		function(q) 
		{ 
			q.executeSql(query, [], 
			function() { alert("file path is saved"); }, 
			function() { alert("file path is not saved"); }
			); 
		});
	}

	showList();
}

function cancel()
{
	showList();
}

function updateEditor()
{
	var textEditor = document.getElementById("textEditor");
	var reportName = document.getElementById("reportName");

	if(!reportId)
	{
		textEditor.value = "";
		reportName.value = "";
		
		return;
	}
	
	db.transaction(
	function(q)
	{
		q.executeSql("select * from report where report_id = ?", [reportId], 
		function(q, result) 
		{ 
			if (result.rows != null)
			{
				textEditor.value = result.rows.item(0)["report_text"];
				reportName.value = result.rows.item(0)["name"];
			}
		});
	});
}

function updateReports()
{
	var select = document.getElementById("areas");
	areaId = select[select.selectedIndex].tagId;
	var div = document.getElementById("reports");
	
	for (var i = div.childNodes.length - 1; i >= 0; i--)
	{
		div.removeChild(div.childNodes[i]);
	}

	db.transaction(
	function(q)
	{
		q.executeSql("select * from report where area_id = ?", [areaId], 
		function(q, result) 
		{
			for (var i = 0; i < result.rows.length; i++)
			{
				var id = result.rows.item(i)["report_id"];
			
				var linkEdit = document.createElement("a");
				linkEdit.tagId = id;
				linkEdit.appendChild(document.createTextNode(result.rows.item(i)["name"]));
				linkEdit.href = "javascript:;";
				linkEdit.onclick = showEditor;
				
				div.appendChild(linkEdit);
				div.appendChild(document.createTextNode(" "));
				
				var linkDelete = document.createElement("a");
				linkDelete.tagId = id;
				linkDelete.appendChild(document.createTextNode("Delete"));
				linkDelete.href = "javascript:;";
				linkDelete.onclick = deleteReport;
				
				div.appendChild(linkDelete);
				div.appendChild(document.createElement("br"));
			}
		});
	});
}

function updateAreas()
{
	var select = document.getElementById("areas");
	select.selected = "0";
	
	for (var i = select.childNodes.length - 1; i >= 0; i--)
	{
		select.removeChild(select.childNodes[i]);
	}
	
	db.transaction(
	function(q)
	{
		q.executeSql("select * from area", [], 
		function(q, result) 
		{ 
			for (var i = 0; i < result.rows.length; i++)
			{
				var option = document.createElement("option");
				option.text = result.rows.item(i)["name"];
				option.tagId = result.rows.item(i)["area_id"];
				
				select.add(option, null);
			}
		});
	});
}

function attachImg(div, path)
{
	var img = document.createElement("img");
	img.src = path;
				
	div.appendChild(img);
	
	/*
	div.appendChild(document.createTextNode(" "));
	
	var linkDelete = document.createElement("a");
	linkDelete.tagId = 
	linkDelete.appendChild(document.createTextNode("Delete"));
	linkDelete.href = "javascript:;";
	linkDelete.onclick = deleteReport;
	
	div.appendChild(linkDelete);
	div.appendChild(document.createElement("br"));
	*/
}

function addFile()
{
	var path = document.getElementById("openFile").value;
	
	if(path != null)
	{
		var div = document.getElementById("files");
		attachImg(div, path);
	}
}

function updateFiles()
{
	paths = new Array();
	var div = document.getElementById("files");
	
	for (var i = div.childNodes.length - 1; i >= 0; i--)
	{
		div.removeChild(div.childNodes[i]);
	}

	db.transaction(
	function(q)
	{
		q.executeSql("select * from file_path where report_id = ?", [report_id], 
		function(q, result) 
		{
			alert(result.rows.length);
		
			for (var i = 0; i < result.rows.length; i++)
			{
				paths[i] = path;
				attachImg(div, path);
			}
		});
	});
}

function deleteReport()
{
	var id = this.tagId;
	
	db.transaction(
	function(q)
	{
		q.executeSql("delete from report where report_id = ?", [id], function() { updateReports(); } );
	});
}

function dropTable(tableName)
{
	db.transaction(function(q) { q.executeSql("drop table " + tableName); });
}

function intitTables()
{
	var exec = function(text)
	{
		db.transaction(function(q) { q.executeSql(text); }); 
	}
	
	exec(
	"create table area (area_id integer primary key, name text not null)"
	);
	
	db.transaction(
	function(q)
	{
		q.executeSql("insert into area (area_id, name) select 1, 'area_1' union all select 2, 'area_2' union all select 3, 'area_3'");
	});
	
	//dropTable(db, "report");
	
	exec(
	"create table report (report_id integer primary key autoincrement, area_id integer not null, name text not null, report_text text not null, foreign key (area_id) references area (area_id))"
	);
	
	/*
	
	db.transaction(
	function(q)
	{
		q.executeSql("insert into report (area_id, name, report_text) " + 
		"select 2, 'report 1', 'some text' union all " + 
		"select 2, 'report 2', 'some text' union all " + 
		"select 2, 'report 3', 'some text'"
		);
	});
	
	db.transaction(
	function(q)
	{
		q.executeSql("select * from report", [], function(q, result) { alert(result.rows.length); });
	});
	*/
	
	exec(
	"create table file_path (file_path_id integer primary key autoincrement, report_id integer not null, value text not null, foreign key (report_id) references report (report_id))"
	);
}

</script>

</head>
<body>

<div align="center" id="reportList">
<br/>
<label>Areas</label>
<select id="areas" onchange="updateReports()"></select><br/><br/>
<div id="reports"></div><br/>
<input type="button" value="Add report" onclick="showEditor()"/>
</div>

<div align="center" id="reportEditor">
<br/>

<label>Name</label>
<input type="text" style="width:350px;" id="reportName"/><br/><br/>
<div>
<Textarea id="textEditor" style="width:400px; height:200px;"></Textarea>
</div>
<br/>
<div id="files"></div><br/>

<div>
<input type="file" accept="image/*" id="openFile">
<input type="button" value="Add file" onclick="addFile()"/>
<input type="button" value="Save" onclick="save()"/>
<input type="button" value="Cancel" onclick="cancel()"/>
</div>

</div>

<script>

db = openDatabase("report_db", "0.1", "Reaport DB", 10000);

if (!db)
{
	alert("Conecting to DB is failed.");
}
else
{
	//dropTable(db, "area");
	
	intitTables();
	updateAreas();
	showList();
}

</script>



</body>
</html>