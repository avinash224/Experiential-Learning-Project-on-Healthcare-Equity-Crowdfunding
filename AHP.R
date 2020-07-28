####Business Evaluation
###ObjectiveThree year survival rate on scales of 1 to 5
      ## Redcrow data is divided into four categories-
         #Technical Skills,Marketability,Entrepreneur skills and Funding
         #Final score- The mean of each category is then multiplied by category weight 
         #Weights used: T,M,E,F=0.45,0.30,15,10


#install.packages("dplyr")
library(dplyr)

#Load dataset
getwd()
data = read_csv('businessAHP.csv')
data



#filter out only company scores
company_dat = data %>% select(-c(Features,Category))
company_dat
#Set company names  as column names
company = colnames(company_dat)
#define categories to filter
cats = c("M","T","F","E")
full_names = c("Markatebility","Technical_skills","Funding","EntrepenuerSkills", "Weighted_Score")
#Assign weights to categories
w_scores = c(0.3,0.45,0.1,0.15)

#subset categories for each company
M = data %>% select(company,Category) %>% filter(Category == "M") %>% select(-Category)
Tr = data %>% select(company,Category) %>% filter(Category == "T") %>% select(-Category)
Fr = data %>% select(company,Category) %>% filter(Category == "F") %>% select(-Category)
E = data %>% select(company,Category) %>% filter(Category == "E")  %>% select(-Category)      
 
M = M %>% summarise_if(is.numeric,mean)
E = E %>% summarise_if(is.numeric,mean)
Tr = Tr %>% summarise_if(is.numeric,mean)
Fr = Fr %>% summarise_if(is.numeric,mean)

MW = M * w_scores[1]
TrW = Tr * w_scores[2]
FrW = Fr * w_scores[3]
EW =  E* w_scores[4]


#combine all category weights for each company
Means=bind_rows(M,Tr,Fr,E)
Weights = bind_rows(MW,TrW,FrW,EW)

#Add category weights to get a final weighted score
Weighted_score = Weights %>% summarise_if(is.numeric,sum)
Final = bind_rows(Means,Weighted_score)
rownames(Final) = full_names
Final

####Clinical Evaluation
### Objective- Three year survival rate on scales of 1 to 5
## Redcrow data is divided into four categories-
#Technical Skills,Marketability,Entrepreneur skills
#Final score- The mean of each category is then multiplied by category weight 
#Weights used: T,M,E,F=0.495,0.34,165
#-The weight had to be adjusted based on initial % as there were no
#features that fell under funding


#install.packages("dplyr")
library(dplyr)
#Load dataset
clinicalAHP = read_csv('clinicalAHP.csv')
clinicalAHP

#filter out only company scores
company_dat = clinicalAHP%>% select(-c(Features,Category))
company_dat

#Set company names  as column names
company = colnames(company_dat)
#define categories to filter
cats = c("T","M","E")
full_names = c("Technical_skills","Markatebility","EntrepenuerSkills", "Weighted_Score")
#Assign weights to categories
w_scores = c(0.495,0.34,0.165)

#subset categories for each company
M =clinicalAHP %>% select(company,Category) %>% filter(Category == "M") %>% select(-Category)
Tr = clinicalAHP %>% select(company,Category) %>% filter(Category == "T") %>% select(-Category)
E = clinicalAHP %>% select(company,Category) %>% filter(Category == "E")  %>% select(-Category)      

#Calculate mean of each category
M = M %>% summarise_if(is.numeric,mean)
E = E %>% summarise_if(is.numeric,mean)
Tr = Tr %>% summarise_if(is.numeric,mean)

#Calculate category weights based on the mean scores
TrW = Tr * w_scores[1]
MW = M * w_scores[2]
EW =  E* w_scores[3]

#combine all category weights for each company
Means=bind_rows(Tr,M,E)
Weights = bind_rows(TrW,MW,EW)

#Add category weights to get a final weighted score
Weighted_score = Weights %>% summarise_if(is.numeric,sum)
ClinicalFinal = bind_rows(Means,Weighted_score)
rownames(ClinicalFinal) = full_names
ClinicalFinal
getwd()

#install.packages("rJava")
library(rJava)
#install.packages("xlsx")
library(xlsx)
write.xlsx(ClinicalFinal, "c:/Users/barsh/Documents/clinicalfinal.xlsx")

