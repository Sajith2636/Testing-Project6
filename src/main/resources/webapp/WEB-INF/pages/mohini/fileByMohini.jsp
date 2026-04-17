<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="spring"%>
<%@ taglib prefix="custom" tagdir="/WEB-INF/tags"%>
<custom:commonElements />

<main id="main" class="main p-0 overflow-hidden">
	<div class="container-fluid">
		
		<!-- ══════════════════════════════════════════════════════════
       TOOLBAR
  ══════════════════════════════════════════════════════════ -->
  <div class="efile-toolbar">

    <!-- Brand / Breadcrumb -->
    <div class="efile-brand">
      <div class="app-icon">
        <i class="fa fa-file-text"></i>
      </div>
      <span class="breadcrumb-text">
        eFile
        <span class="separator">/</span>
        <span class="section">Closed</span>
      </span>
      <div class="loading-dots">
        <span></span><span></span><span></span>
      </div>
    </div>

    <div class="toolbar-spacer"></div>
<div class="toolbar-right">
    <!-- Search -->
    <div class="toolbar-search">
      <input type="text" placeholder="Search by Subject" id="dynamic_search">
      <button class="search-btn" title="Search">
        <i class="fa fa-search"></i>
      </button>
    </div>

    <!-- Filter -->
    <button class="toolbar-icon-btn filter-btn" title="Filter">
      <i class="fa-solid fa-filter"></i>
    </button>

    <!-- Grid / Columns toggle -->
    <button class="toolbar-icon-btn grid-btn" title="Column Settings">
      <i class="fa-solid fa-border-all"></i>
    </button>

    <div class="toolbar-divider"></div>

    <!-- Send -->
    <button class="toolbar-action-btn btn-send" title="Send">
      <i class="fa-solid fa-paper-plane"></i>
      <span>Send</span>
    </button>

    <!-- Put in File -->
    <button class="toolbar-action-btn btn-putinfile" title="Put in File">
      <i class="fa-solid fa-paperclip"></i>
      <span>Put in File</span>
    </button>

    <!-- Copy -->
    <button class="toolbar-action-btn btn-copy" title="Copy">
      <i class="fa-solid fa-copy"></i>
      <span>Copy</span>
    </button>

    <!-- Close -->
    <button class="toolbar-action-btn btn-close-efile" title="Close">
      <i class="fa-solid fa-circle-xmark"></i>
      <span>Close</span>
    </button>
</div>
  </div><!-- /toolbar -->
		
		
		<section class="section">
			
		<div class="col-12">
						<div class="card card-hgt common-tablediv">
							<div class="rcard-body">
								<div class="table-rounded">
								    <table id="FileClosedTable" class="display">
								        <thead>
								            <tr>
								                <th></th>
												<th>Comp No.</th>
												<th>File No.</th>
								                <th>Subject</th>
								                <th>Priority</th>
								                <th>Sent By</th>
								                <th>Sent On</th>
								                <th>Read On</th>
								                <th>Due On</th>
								                <th>Remarks</th>
								            </tr>
								        </thead>
								        <tbody>   
								        </tbody>
								    </table>
								</div>
							</div>
						</div>
					</div>
		</section>
	</div>
</main>

<script nonce="${cspNonce}" type="text/javascript">

$(document).ready(function () {
	
    var table = $('#FileClosedTable').DataTable({
        processing: true,
        serverSide: true,
        dom: '<"top"f>rt<"bottom"<"il-wrap"il>p><"clear">',
        "scrollCollapse": true, 
		"scrollX": true,  
     	"iDisplayLength": 20,
     	"aLengthMenu": [[10, 20, 50, -1], [10, 20, 50, "All"]],
        ajax: {
            url: '/api/file/Created',
            type: 'POST',
            contentType: 'application/json',
            headers: {
		        "EmpSeqNo": "001000093574",
		        "ForceNo": "127410993",
		        "Name": "VIRENDER KUMAR BHANDARI",
		        "NamewithDesc": "VIRENDER KUMAR BHANDARI, GOs ENTITLEMENT, DTE-GEN",
		        "Posts": "1002",
		        "PostName": "PIS-IT-DG",
		        "BranchId": "10",
		        "UnitId": "999",
		        "Delegated": "N"
		    },
            data: function (d) {
                return JSON.stringify({
                	postId: "1002",
                    start: d.start,
                    length: d.length,
                    draw: d.draw,
                    search: d.search.value,
					orderColumn: d.columns[d.order[0].column].data,
                    orderDir: d.order[0].dir
                });
            },
            dataSrc: function (json) {
            	json.recordsTotal = json.data.recordsTotal;
                json.recordsFiltered = json.data.recordsFiltered; 
                return json.data.data;
            }
        },
		columns: [
		            {
		                data: 'id',
		                render: function (data) {
		                    return '<input type="checkbox" class="rowCheckbox" value="' + data + '">';
		                },
		                orderable: false,
		                searchable: false
		            },
		            { data: 'computerNumber', defaultContent: '' },
		            {
		                data: 'documentId',
		                defaultContent: '',
		                render: function (data) {
		                    return data ? '<a href="files_view?id=' + data + '">' + data + '</a>' : '';
		                }
		            },
					{ data: 'subject', defaultContent: '' },
		            { data: 'priority', defaultContent: '' },
		            { data: 'senderName', defaultContent: '' },
		            { data: 'sentOn', defaultContent: '' },
		            { data: 'readOn', defaultContent: '' },
		            { data: 'dueOn', defaultContent: '' },
		            { data: 'remarks', defaultContent: '' }
		        ]
    });
	//Dynamic Search (with debounce)
    let timer;
    $("#dynamic_search").on("keyup", function () {
        clearTimeout(timer);
        let value = this.value;

        timer = setTimeout(function () {
            table.search(value).draw();
        }, 400); // delay for performance
    });

    // Search button click
    $(".search-btn").on("click", function () {
        let value = $("#dynamic_search").val();
        table.search(value).draw();
    });
});
$(document).on("change", ".rowCheckbox", function () {
        if ($(this).is(":checked")) {
            $(".rowCheckbox").not(this).prop("checked", false);
        }
    });
</script>