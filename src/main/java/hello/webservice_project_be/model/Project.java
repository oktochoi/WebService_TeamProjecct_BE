package hello.webservice_project_be.model;

import java.sql.Timestamp;

public class Project {
    private int id;
    private String name;
    private String description;
    private String repoUrl;
    private String status;
    private int members;
    private int contributionScore;
    private int totalCommits;
    private int totalPullRequests;
    private int totalIssues;
    private Timestamp createdAt;
    private Timestamp lastUpdated;
    private String userId;
    
    public Project() {
    }
    
    public Project(String name, String description, String repoUrl, String userId) {
        this.name = name;
        this.description = description;
        this.repoUrl = repoUrl;
        this.userId = userId;
        this.status = "진행중";
        this.members = 0;
        this.contributionScore = 0;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getRepoUrl() {
        return repoUrl;
    }
    
    public void setRepoUrl(String repoUrl) {
        this.repoUrl = repoUrl;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getMembers() {
        return members;
    }
    
    public void setMembers(int members) {
        this.members = members;
    }
    
    public int getContributionScore() {
        return contributionScore;
    }
    
    public void setContributionScore(int contributionScore) {
        this.contributionScore = contributionScore;
    }
    
    public int getTotalCommits() {
        return totalCommits;
    }
    
    public void setTotalCommits(int totalCommits) {
        this.totalCommits = totalCommits;
    }
    
    public int getTotalPullRequests() {
        return totalPullRequests;
    }
    
    public void setTotalPullRequests(int totalPullRequests) {
        this.totalPullRequests = totalPullRequests;
    }
    
    public int getTotalIssues() {
        return totalIssues;
    }
    
    public void setTotalIssues(int totalIssues) {
        this.totalIssues = totalIssues;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getLastUpdated() {
        return lastUpdated;
    }
    
    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
}

