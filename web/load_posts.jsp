<%@page import="com.techblog.entities.User"%>
<%@page import="com.techblog.dao.LikeDao"%>
<%@page import="com.techblog.dao.UserDao"%>
<%@page import="java.util.List"%>
<%@page import="com.techblog.entities.Post"%>
<%@page import="com.techblog.helper.ConnectionProvider"%>
<%@page import="com.techblog.dao.PostDao"%>


<!--css-->  
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<link href="css/mystyle.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
    .User-name{
        font-style: italic;
    }
</style>
<div class="row">

    <%
        User u = (User)session.getAttribute("currentUser");

        Thread.sleep(500);
        LikeDao ldao = new LikeDao(ConnectionProvider.getConnection());
        UserDao udao = new UserDao(ConnectionProvider.getConnection());
        PostDao dao = new PostDao(ConnectionProvider.getConnection());
        int cid = Integer.parseInt(request.getParameter("cid"));
        List<Post> posts = null;

        if (cid == 0) {
            posts = dao.getAllPosts();
        } else {
            posts = dao.getPostbyCatId(cid);

        }

        if (posts.size() == 0) {
            out.println("<h3 class='display-3 text-center'>No  posts in this category...</h3>");
            return;
        }
        for (Post p : posts) {
    %>
    <div class="col-md-10 mt-2">
        <div class="card">
            <img class="card-img-top" src="post_pics/<%= p.getpPic()%>" alt="Card image cap">
            <div class="card-body">
                <%
                    UserDao ud = new UserDao(ConnectionProvider.getConnection());
                %>
                <b class="User-name"><%= ud.getUserbyUserId(p.getUserId()).getName()%></b> 
                <br>
                <b><%= p.getpTitle()%></b>

                <p><%= p.getpContent()%></p>

            </div>

            <div class="card-footer text-center primary-background" >
                <% boolean b=ldao.isLikedByUser(p.getpId(), u.getId());
                if(!b){
                    %>
                <a href="#!" onclick="doLike(<%= p.getpId()%>,<%= u.getId()%>)" class=" btn btn-outline-light  btn-sm "><span id="likeid<%= p.getpId() %>" class="btn btn-danger fa fa-heart"><%= ldao.countLikeonPost(p.getpId())%></span></a>
<% }
else{
%>
                <a href="#!" onclick="doLike(<%= p.getpId()%>,<%= u.getId()%>)" class=" btn btn-outline-light  btn-sm "><span id="likeid<%= p.getpId() %>" class="btn btn-outline-success fa fa-heart"><%= ldao.countLikeonPost(p.getpId())%></span></a>
<% 
    }
%>
                <a href="show_post_page.jsp?post_id=<%= p.getpId()%>" class=" btn btn-outline-light  btn-sm ">Read more...</a>


                <a href="#!" class=" btn btn-outline-light  btn-sm "><i class="fa fa-commenting-o"></i><span> 20</span></a>
            </div>
        </div>

    </div>
    <%
        }

    %>
</div>

<!--javascript-->
<script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<script src="js/myjs.js" type="text/javascript"></script>


<script>
                    function doLike(post, sender) {
                        console.log(post + "," + sender);
                        const d = {
                            post: post,
                            sender: sender,

                        }
                        $.ajax({
                            url: "LikeServlet",
                            data: d,
                            success: function (data, textStatus, jqXHR) {
                                console.log(data);
                                if ($("#likeid"+post).hasClass("btn-danger")) {
                                    let c = $("#likeid"+post).html();
                                    c++;
                                    $("#likeid"+post).html(c);
                                    $("#likeid"+post).removeClass("btn-danger");
                                    $("#likeid"+post).addClass("btn-outline-success");
                                }else{
                                    let c = $("#likeid"+post).html();
                                    c--;
                                    $("#likeid"+post).html(c);
                                      $("#likeid"+post).removeClass("btn-outline-success");
                                    $("#likeid"+post).addClass("btn-danger");
                                }
                                
                            },
                            error: function (jqXHR, textStatus, errorThrown) {
                                console.log(data);
                            }

                        })
                    }
</script>

