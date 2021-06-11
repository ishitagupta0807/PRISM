
package com.techblog.dao;
import com.techblog.entities.Comments;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class CommentDao {
    Connection con;

    public CommentDao(Connection con) {
        this.con = con;
    }
    
    public boolean insertComment(Comments co){
        boolean f=false;
        try {
            String q="insert into commentss (coContent,pidd,uidd,coReply) values(?,?,?,?) ";
            PreparedStatement pstmt=this.con.prepareStatement(q);
            pstmt.setString(1, co.getCoContent());
            pstmt.setInt(2, co.getPid());
            pstmt.setInt(3, co.getUid());
            pstmt.setString(4, co.getCoReply());
            
            pstmt.executeUpdate();
            f=true;
        } catch (Exception e) {
        e.printStackTrace();
        }
        return f;
    }
    
    public int countCommentonPost(int pid){
        int count=0;
        try {
            String q="select count(*) from commentss where pidd=?";
            PreparedStatement pstmt=this.con.prepareStatement(q);
            
            pstmt.setInt(1, pid);
            ResultSet set=pstmt.executeQuery();
            
            if(set.next()){
                count=set.getInt("count(*)");
            }
        } catch (Exception e) {
       e.printStackTrace();
        }
        return count;
    }
    
   public List<Comments> getCommentsbyPostid(int pid){
    List<Comments> list=new ArrayList<>();
       try {
           PreparedStatement p=this.con.prepareStatement("select * from commentss where pidd=?");
           p.setInt(1, pid);
           ResultSet set=p.executeQuery();
           while(set.next()){
               int pId=set.getInt("pidd");
               int coId=set.getInt("coId");
               String coContent=set.getString("coContent");
               int uid=set.getInt("uidd");
               String coReply=set.getString("coReply");
               
               Comments co;
               co=new Comments(coId, coContent, coReply, pid, uid);
               list.add(co);
           }
       } catch (Exception e) {
       e.printStackTrace();
       }
    return list;
}
    
    public boolean deleteComment(int coId, int uid){

 boolean f=false;
        try {
            String q="delete from commentss where coId=? and uidd=?";
           PreparedStatement pstmt=this.con.prepareStatement(q);
            pstmt.setInt(1, coId);
            pstmt.setInt(2,uid);
           
           
            pstmt.executeUpdate();
           
            f=true;
        } catch (Exception e) {
        }
        return f;
    }
}

