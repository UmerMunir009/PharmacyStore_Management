import pyodbc
from faker import Faker
import random
import datetime
from datetime import  timedelta,time

conn_string = 'DRIVER={SQL Server};SERVER=DESKTOP-F75OQSU\\SQLEXPRESS;DATABASE=project;Trusted_Connection=yes;'

fake = Faker()
# Connect to the database
with pyodbc.connect(conn_string) as conn:
    cursor = conn.cursor()
 
customer_names = [
    "Ahmed Ali", "Sara Khan", "Usman Qureshi", "Fatima Zahra", "Bilal Ahmed", "Ayesha Siddiqui", "Mohammad Amir", "Nida Raza", "Hassan Abbas", "Sana Malik",
    "Ali Raza", "Zainab Bibi", "Kamran Shah", "Hina Javed", "Rizwan Haider", "Farah Yousuf", "Omar Farooq", "Saira Anwar", "Salman Butt", "Amina Tariq",
    "Yasir Mehmood", "Iqra Asif", "Naveed Alam", "Samina Parveen", "Fahad Sheikh", "Shaista Khan", "Adnan Shahid", "Rabia Qazi", "Tariq Aziz", "Uzma Shah",
    "Waqas Hussain", "Shazia Jameel", "Imran Abbas", "Rubina Munir", "Zeeshan Ali", "Mehwish Naqvi", "Noman Javed", "Aqsa Rafiq", "Rehan Qadir", "Areeba Shahid",
    "Arif Khan", "Saima Rashid", "Jawad Ahmed", "Kiran Akhtar", "Faraz Haider", "Bushra Iqbal", "Rafay Khan", "Lubna Mirza", "Khurram Shahzad", "Saba Qureshi",
    "Asif Mahmood", "Asma Farooq", "Waleed Ahmed", "Shaheen Jaffar", "Faisal Raza", "Sumaira Malik", "Hamza Tariq", "Sania Anwar", "Mansoor Ali", "Nazia Khalid",
    "Zubair Ahmed", "Ayesha Malik", "Shahid Iqbal", "Tahira Begum", "Riaz Ahmed", "Nasreen Akhtar", "Saad Rauf", "Noreen Akhtar", "Talha Shah", "Sadia Khan",
    "Kamran Ahmed", "Rabia Khan", "Atif Nawaz", "Naila Arif", "Arsalan Javed", "Uzma Riaz", "Furqan Ali", "Aalia Parveen", "Waqar Hussain", "Nadia Khan",
    "Babar Ali", "Kalsoom Riaz", "Amir Farooq", "Salma Bibi", "Faisal Ahmed", "Sahar Malik", "Shahbaz Khan", "Shumaila Rehman", "Asad Abbas", "Tahira Yousuf",
    "Murtaza Ali", "Saima Malik", "Qasim Shah", "Sidra Javed", "Haris Khan", "Tehmina Rashid", "Kashif Ali", "Sadaf Abbas", "Noman Sheikh", "Fariha Rizwan",
    "Adil Mehmood", "Humaira Javed", "Zaid Khan", "Munazza Qureshi", "Mubashir Ali", "Aisha Anwar", "Tahir Raza", "Shagufta Shah", "Waheed Ahmed", "Shehla Siddiqui",
    "Saif Ullah", "Ayesha Shah", "Fawad Khan", "Irum Farooq", "Faizan Raza", "Rafia Anwar", "Zain Ahmed", "Yasmin Akhtar", "Umar Aslam", "Tahira Tariq",
    "Adeel Malik", "Naila Sheikh", "Waqas Ahmed", "Shazia Haider", "Raheel Khan", "Sadia Qureshi", "Adeel Ahmed", "Huma Tariq", "Irfan Ahmed", "Sania Farooq",
    "Hamid Raza", "Bushra Khan", "Naveed Ahmed", "Nasira Bibi", "Hassan Raza", "Mehwish Tariq", "Kamran Khan", "Samina Bibi", "Ahmad Raza", "Rubina Shah",
    "Omar Qureshi", "Uzma Khalid", "Sajjad Ali", "Nadia Riaz", "Furqan Raza", "Saba Malik", "Kashif Raza", "Mehwish Akhtar", "Sami Ullah", "Sidra Raza",
    "Babar Hussain", "Zara Khan", "Asif Ali", "Sadia Iqbal", "Salman Raza", "Sadia Malik", "Faisal Khan", "Shumaila Tariq", "Zahid Raza", "Saima Qureshi",
    "Murtaza Khan", "Shazia Iqbal", "Talha Raza", "Sadia Farooq", "Waseem Ali", "Sumaira Tariq", "Ahmed Raza", "Rubina Qureshi", "Asad Khan", "Sahar Bibi",
    "Zubair Raza", "Farah Tariq", "Waqas Malik", "Sadaf Khan", "Kashif Ahmed", "Hina Qureshi", "Saad Ullah", "Sania Raza", "Rafay Ahmed", "Bushra Qadir",
    "Fahad Raza", "Nasreen Bibi", "Naveed Raza", "Kiran Shah", "Hamza Ahmed", "Mehwish Khan", "Talha Raza", "Samina Qadir", "Arif Raza", "Shumaila Qureshi",
    "Bilal Khan", "Tahira Javed", "Sajjad Khan", "Sidra Tariq", "Hassan Ahmed", "Naila Jameel", "Asim Raza", "Tahira Malik", "Tahir Raza", "Shagufta Farooq",
    "Waqas Ali", "Shehla Khan", "Babar Ahmed", "Noreen Tariq", "Sami Khan", "Sadaf Ahmed", "Adeel Raza", "Uzma Qadir", "Hamid Khan", "Aisha Raza",
    "Riaz Khan", "Huma Qureshi", "Faisal Shah", "Sadia Malik", "Noman Ahmed", "Tahira Qureshi", "Zeeshan Raza", "Bushra Malik", "Qasim Ahmed", "Sadaf Shah",
    "Zahid Ahmed", "Tehmina Bibi", "Bilal Raza", "Nasira Malik", "Furqan Shah", "Sumaira Khan", "Ahmed Raza", "Sadaf Qureshi", "Usman Shah", "Shazia Raza",
    "Kamran Raza", "Rubina Khan", "Arsalan Raza", "Sahar Qadir", "Mubashir Ahmed", "Naila Raza", "Hassan Khan", "Noreen Raza", "Babar Raza", "Sadia Jameel",
    "Arif Ahmed", "Shehla Qadir", "Asif Shah", "Hina Raza", "Naveed Khan", "Shumaila Khan", "Fawad Raza", "Tahira Raza", "Furqan Ahmed", "Sadaf Malik",
    "Zaid Ahmed", "Sidra Raza", "Zeeshan Khan", "Saba Farooq", "Arif Ali", "Sadia Qadir", "Hamza Raza", "Tahira Qadir", "Babar Shah", "Sadia Anwar",
    "Faisal Raza", "Shazia Tariq", "Raheel Ahmed", "Shumaila Qadir", "Tahir Ahmed", "Sidra Malik", "Zeeshan Shah", "Sahar Tariq", "Farhan Khan", "Rubina Tariq",
    "Ahmed Raza", "Hina Khan", "Noman Raza", "Tahira Shah", "Zubair Khan", "Sumaira Qadir", "Adeel Shah", "Saba Anwar", "Sami Raza", "Sadia Qureshi",
    "Asad Ahmed", "Shagufta Raza", "Arsalan Ahmed", "Sadia Tariq", "Murtaza Raza", "Sahar Raza", "Kashif Shah", "Sadaf Qadir", "Talha Ahmed", "Sania Malik",
    "Qasim Raza", "Shumaila Tariq", "Usman Raza", "Tahira Malik", "Omar Raza", "Saba Qadir", "Asif Raza", "Sadia Shah", "Zeeshan Ahmed", "Tahira Anwar",
    "Bilal Shah", "Sadia Farooq", "Asad Raza", "Sadia Malik", "Tahir Raza", "Sahar Khan", "Fawad Ahmed", "Rubina Raza", "Hamid Raza", "Sumaira Shah",
    "Zahid Raza", "Sadia Qureshi", "Faraz Khan", "Tahira Malik", "Zubair Raza", "Sumaira Farooq", "Naveed Raza", "Shumaila Raza", "Usman Khan", "Sadia Tariq",
    "Kamran Ahmed", "Shumaila Malik", "Asif Raza", "Naila Raza", "Ahmed Raza", "Tahira Qureshi", "Farhan Ahmed", "Rubina Qadir", "Sajjad Ahmed", "Sadaf Raza",
    "Zeeshan Shah", "Sumaira Javed", "Hassan Raza", "Sadia Qadir", "Hamza Khan"]

def generate_cnic():
    cnic = '35202'
    for _ in range(7):
        cnic += str(random.randint(0, 9))
    return cnic

unique_cnic_set = set()
while len(unique_cnic_set) < 2000:
    unique_cnic_set.add(generate_cnic())

unique_cnic_list = list(unique_cnic_set)

Addresses = ['268, Garden Town, C1', '429, Gulberg, C1', '610, Ghaziabad, F2', '464, Defence, E2', '614, Sadar, B3', '970, Defence, G2', '538, Lahore Road, D3', '413, Defence, B2', '693, Defence, B2', '730, Cantt, G1', '874, Bahria Town, F1', '901, Faisal Town, F3', '276, Cantt, B1', '172, Bahria Town, F1', '26, Railway Road, B3', '260, Garden Town, G2', '325, Garden Town, H2', '64, Samanabad, E3', '40, College Road, C2', '70, Cantt, H2', '601, Wapda Town, C2', '327, Lahore Road, H2', '703, Garden Town, D2', '463, Gulberg, D3', '681, Faisal Town, H2', '315, Sadar, E2', '164, Lahore Road, F1', '355, Samanabad, B1', '118, Township, F1', '509, Defence, B2', '923, Wapda Town, D3', '948, Garden Town, E2', '367, Wapda Town, H3', '494, Iqbal Town, H3', '362, College Road, D3', '631, Main Boulevard, D3', '878, Garden Town, E1', '3, Lahore Road, H3', '650, Shadman, B1', '374, Sadar, E3', '124, Johar Town, H2', '604, Gulberg, F1', '492, Iqbal Town, B3', '995, Model Town, D2', '348, Defence, H3', '882, College Road, D2', '335, Lahore Road, D2', '848, Ghaziabad, B3', '869, Shadman, E3', '63, Shadman, G2', '461, Samanabad, H3', '669, Shadman, E3', '956, Johar Town, B1', '216, Sadar, F3', '454, Iqbal Town, E2', '373, Garden Town, F1', '698, Iqbal Town, E1', '490, Bahria Town, G2', '360, Johar Town, C2', '511, Bahria Town, C1', '812, Wapda Town, H2', '737, Shadman, E2', '511, Iqbal Town, C2', '812, Defence, D3', '51, Wapda Town, C3', '402, Shadman,C1', '640, Defence, D2', '900, Township, D1', '490, Railway Road, B1', '486, Bahria Town, D3', '399, Ghaziabad, G3', '677, Sadar, D3', '938, Wapda Town, C2', '866, Main Boulevard, D2', '260, Johar Town, D2', '792, Johar Town, D1', '699, Bahria Town, D3', '715, Ghaziabad, B2', '168, Johar Town, E2', '256, Iqbal Town, D3', '338, Lahore Road, H1', '869, Samanabad, F2', '78, Garden Town, F2', '348, College Road, F3', '439, Defence, H1', '452, Gulberg, F3', '804, Garden Town, E1', '565, Sadar, C2', '924, Lahore Road, D1', '833, Sadar, E3', '38, Cantt, H3', '725, Iqbal Town, C2', '825, Ghaziabad, B1', '763, Railway Road, D2', '977, Railway Road,B1', '478, Defence, C3', '560, Bahria Town, D2', '975, Defence, G1', '808, Sadar, B2', '868, Faisal Town, B3', '21, Defence, F3', '892, Gulberg, H2', '596, Ghaziabad, D3', '893, Iqbal Town, D3', '56, Ghaziabad, D2', '957, Iqbal Town, E1', '632, Johar Town, B1', '981, Ghaziabad, B2', '311, Township, E1', '869, Faisal Town,D3', '869, College Road, C1', '701, Garden Town, E1', '640, Lahore Road, G1', '407, Cantt, D2', '511, Bahria Town, B2', '761, Samanabad, E2', '908, Lahore Road, G1', '787, Township, C3', '124, Iqbal Town, E1', '371, Railway Road, B1', '955, Railway Road, G2', '349, Main Boulevard, H3', '716, Model Town, E1', '207, Cantt, B3', '324, Railway Road, C2', '701, Garden Town, G1', '367, Shadman, G3', '725, Defence, B1', '28, Johar Town, D2', '908, Railway Road, E1', '907, Cantt, B2', '787, Lahore Road, D2', '341, Garden Town, B1', '755, Garden Town, D2', '559, Bahria Town, D2', '68, Sadar, H1', '417, Defence, B1', '503, Township, D3', '870, Township, C2', '243, Bahria Town, H3', '938, Shadman, E3', '244, Gulberg, D3', '862, Bahria Town, H3', '517, Shadman, B2', '719, Gulberg, B1', '963, Cantt, D1', '364, Model Town, G1', '777, Garden Town, G1', '804, College Road, B1', '402, Faisal Town, H3', '882, Iqbal Town, C2', '290, Sadar, E3', '767, Bahria Town, B1', '979, Cantt, H2', '507, College Road, G3', '424, Railway Road, D1', '494, Railway Road, H2', '245, Cantt, H1', '915, Johar Town, E3', '749, Bahria Town, C2', '116, Township, H2', '626, Ghaziabad, C2', '67, Bahria Town, G3', '883, Faisal Town, H1', '36, Bahria Town, H1', '573, Johar Town, C1', '438, Model Town, B2', '576, Ghaziabad, E3', '131, Bahria Town, D2', '321, Samanabad, F3', '836, Johar Town, G1', '551, Railway Road, F3']

prefixes = [
    "0300", "0301", "0302", "0303", "0304", "0305", "0306", "0307", "0308", "0309",
    "0340", "0341", "0342", "0343", "0344", "0345", "0346", "0347", "0348", "0349"
]

def generate_phone_numbers(count):
    phone_numbers = set()
    
    while len(phone_numbers) < count:
        prefix = random.choice(prefixes)
        suffix = ''.join(random.choices("0123456789", k=7))
        phone_number = f"{prefix}-{suffix}"
        phone_numbers.add(phone_number)
    
    return list(phone_numbers)


unique_ph_numbers = generate_phone_numbers(2000)

cusType=["On-Site","Remote"]

def Customer_Records(i):

       random_CNIC =unique_cnic_list[i]
       random_name = random.choice(customer_names)
       random_mblNum = unique_ph_numbers[i]
       random_address=random.choice(Addresses)
       random_type=random.choice(cusType)
       params = (random_CNIC, random_name, random_address, random_mblNum,random_type)
       cursor.execute("EXEC InsertCustomer ?, ?, ?, ?, ?", params)

       conn.commit()


i=-1
[Customer_Records(i := i + 1) for _ in range(2000)]


# ------------------------------------------------------------------------------------------------------------------------------------------------------------
def insert_employee_info():
        emp_types = ['On-Site', 'Delivery Boy']  

        for emp_type in emp_types:
            if emp_type == 'On-Site':
                salary = 50000
            elif emp_type == 'Delivery Boy':
                salary = 30000

            params = (emp_type, salary)
            cursor.execute("EXEC InsertEmployeeInfo ?, ?", params)

        conn.commit()

insert_employee_info()
#   # -----------------------------------------------------------------------------------------------------------------

prefix = "EMP"
def generate_empID(count):
    empIDs = [f"{prefix}{i}" for i in range(1, count + 1)]
    return empIDs

unique_empIDs = generate_empID(15)




employee_names = [
     "Bilal Ahmed", "Hassan Abbas","Ali Raza","Kamran Shah","Rizwan Haider", "Farah Yousuf", "Omar Farooq", "Saira Anwar", "Salman Butt", "Amina Tariq",
    "Yasir Mehmood", "Iqra Asif", "Naveed Alam", "Samina Parveen", "Fahad Sheikh", "Shaista Khan", "Adnan Shahid", "Rabia Qazi", "Tariq Aziz", "Uzma Shah",
    "Waqas Hussain", "Shazia Jameel", "Imran Abbas", "Rubina Munir", "Zeeshan Ali", "Mehwish Naqvi", "Noman Javed", "Aqsa Rafiq", "Rehan Qadir", "Areeba Shahid",
    "Arif Khan", "Saima Rashid", "Jawad Ahmed", "Kiran Akhtar", "Faraz Haider"]

emp_ph_prefixes = [
    "0310", "0311", "0312", "0313","0331", "0332", "0333", "0334", "0344"]

def generate_emp_phNumbers(count):
    phone_numbers = set()
    
    while len(phone_numbers) < count:
        prefix = random.choice(prefixes)
        suffix = ''.join(random.choices("0123456789", k=7))
        phone_number = f"{prefix}-{suffix}"
        phone_numbers.add(phone_number)
    
    return list(phone_numbers)


unique_emp_phoneNumbers = generate_emp_phNumbers(15)


Emp_Addresses = [
    "345 Main Street, Lahore, Punjab","123 Avenue, Lahore, Punjab","789 Lane, Lahore, Punjab","456 Road, Lahore, Punjab","890 Boulevard, Lahore, Punjab",
    "234 Street, Lahore, Punjab","567 Lane, Lahore, Punjab","321 Avenue, Lahore, Punjab","901 Road, Lahore, Punjab","678 Street, Lahore, Punjab",
    "123 Avenue, Lahore, Punjab","456 Lane, Lahore, Punjab","789 Street, Lahore, Punjab","234 Road, Lahore, Punjab","567 Boulevard, Lahore, Punjab","890 Street, Lahore, Punjab","123 Road, Lahore, Punjab","456 Lane, Lahore, Punjab","789 Street, Lahore, Punjab","234 Road, Lahore, Punjab","567 Lane, Lahore, Punjab","890 Avenue, Lahore, Punjab","123 Lane, Lahore, Punjab"
]
fromdate = datetime.date(2021, 1, 1)
todate = datetime.date(2023, 12, 31)
num_dates = 20 
joining_dates = []
for _ in range(num_dates):
    random_date = fromdate + timedelta(days=random.randint(0, (todate - fromdate).days))
    joining_dates.append(random_date.strftime("%Y-%m-%d"))

emp_types = ['On-Site', 'Delivery Boy']  

def Employee_Records(i):

       random_ID =unique_empIDs[i]
       random_name = random.choice(employee_names)
       random_mblNum = unique_emp_phoneNumbers[i]
       random_address=random.choice(Emp_Addresses)
       random_type=random.choice(emp_types)
       random_joiningdate=random.choice(joining_dates)
       params = (random_ID, random_name, random_mblNum,random_address,random_joiningdate,random_type)
       cursor.execute("EXEC InsertEmployee ?, ?, ?, ?, ?, ?", params)

       conn.commit()


i=-1
[Employee_Records(i := i + 1) for _ in range(15)]

# # ------------------------------------------------------------------------------------------------------------------------------------------------------------

prefix = "MD"
def generate_medID(count):
    medIDs = [f"{prefix}{i}" for i in range(1, count + 1)]
    return medIDs

unique_medIDs = generate_medID(300)

medicines_names = [
    'Hydrocodone Bitartrate/Acetaminophen', 'Zithromax', 'Levetiracetam Oral Solution', 'Thioguanine', 'Nevirapine', 'Interferon alfa-2a and alfa-2b', 
    'Procarbazine', 'Mechlorethamine', 'Dronabinol', 'Sacubitril/valsartan (Entresto®)', 'Voriconazole', 'Famciclovir', 'Nortriptyline', 'Dextroamphetamine', 
    'Promethazine topical gel', 'Mitoxantrone', 'Metoprolol', 'Doxazosin', 'Elvitegravir / cobicistat / emtricitabine / tenofovir alafenamide (Genvoya®)', 
    'Atazanavir (Reyataz®)', 'Teniposide', 'Tretinoin (applied to the skin)', 'Hydroxyzine', 'Diltiazem','Buspirone', 'Amoxicillin Oral', 'Ciprofloxacin/Dexamethasone', 
    'Lansoprazole', 'Anti-thymocyte globulin', 'Phosphorus', 'Acetaminophen/Hydrocodone Bitartrate', 'Metformin/Glipizide', 'Gabapentin/Enacarbil', 'Tretinoin', 
    'Etonogestrel (Nexplanon®)', 'Dicyclomine', 'Naproxen', 'Ciprofloxacin', 'Erlotinib', 'Montelukast', 'Enoxaparin', 'Cefuroxime', 'Propoxyphene', 'Hydralazine', 
    'Alendronate Sodium', 'Hydroxychloroquine Sulfate', 'Micafungin', 'Daunorubicin', 'Phenobarbital', 'Prednisone', 'Sucralfate', 'Methylprednisolone', 
    'Hydroxyzine/Pamoate', 'GM-CSF (Sargramostim)', 'Irinotecan', 'Oxybutynin', 'Lopinavir / Ritonavir (Kaletra®)', 'Ceftriaxone', 'Naproxen Sodium', 'Doxepin', 
    'Aprepitant', 'Doxorubicin', 'Amikacin', 'Trimethoprim / sulfamethoxazole', 'Venlafaxine', 'Hydrocodone/Acetaminophen', 'Fluocinonide Topical Solution', 
    'Metoclopramide', 'Alprazolam', 'Efavirenz / emtricitabine / tenofovir (Atripla®)', 'Heparin Lock Flush for infants', 'Nelarabine', 'Losartan/Hydrochlorothiazide', 
    'Quetiapine', 'Pentamidine (inhaled by mouth)', 'Paracetamol', 'Cladribine', 'Leucovorin with high dose methotrexate (HDMTX)', 'Fexofenadine', 
    'Estradiol Transdermal System', 'Mupirocin', 'Asparaginase', 'Megestrol acetate', 'Levothyroxine', 'Etravirine (Intelence®)', 'Sildenafil', 'Captopril', 'Bortezomib', 
    'Vancomycin', 'Fludarabine', 'Regorafenib', 'Ibuprofen', 'Carmustine', 'Zidovudine', 'Doxycycline', 'Lisinopril', 'Insulin Lispro', 'Olanzapine', 
    'Raltegravir (Isentress®)', 'Insulin Glargine', 'Nystatin Oral Suspension', 'Factor IX complex', 'Albuterol', 'Salmeterol', 'Phenazopyridine', 'Ketoconazole', 
    'Atovaquone', 'Guanfacine', 'Metronidazole Topical', 'Potassium', 'Bleomycin', 'Clindamycin/Benzoyl Peroxide', 'Emtricitabine / tenofovir (Truvada®)', 
    'Clindamycin Phosphate', 'Abacavir / dolutegravir / lamivudine (Triumeq®)', 'Maraviroc (Selzentry®)', 'Gabapentin', 'Dicyclomine Hydrochloride', 'Atenolol', 
    'Busulfan', 'Ranitidine Hydrochloride', 'Aminocaproic Acid', 'Fluorouracil', 'Probenecid', 'Budesonide', 'Miconazole', 'Rilpivirine / emtricitabine / tenofovir (Complera®)', 'Norethindrone Acetate/Ethinyl Estradiol', 'Amifostine', 'Metronidazole', 'Lipitor', 'Enalapril', 'Chlorhexidine Gluconate', 'Magnesium', 
    'Erythropoietin', 'Hydroxyzine Hydrochloride', 'Insulin Aspart', 'Fenofibric Acid', 'Cyclophosphamide', 'Foscarnet', 'Atorvastatin', 'Pemetrexed', 'Rasburicase', 
    'Aripiprazole', 'Prednisolone/Sulfacetamide', 'Hydrochlorothiazide/Lisinopril', 'Azithromycin Dihydrate', 'Modafinil', 'Clonazepam', 'Cyproheptadine', 'Methadone', 
    'Neuromuscular blockers', 'Gefitinib', 'Interleukin-2 (Aldesleukin)', 'Alemtuzumab', 'Fentanyl', 'Bimatoprost', 'Rifaximin', 'Mometasone Furoate', 
    'Rosuvastatin', 'Ranitidine', 'Metformin', 'Ceftazidime', 'Allopurinol', 'Hydrochlorothiazide', 'Methylphenidate', 'Metoprolol Succinate', 'Saquinavir', 
    'Estradiol', 'Factor VIII (Human) and von Willebrand Factor', 'Tenofovir', 'Dasatinib', 'L-glutamine', 'Ampicillin', 'Meropenem', 'Abacavir', 'Amphotericin B', 
    'Codeine', 'Diclofenac Sodium', 'Tretinoin by mouth', 'Tolterodine', 'Cefixime', 'Letrozole', 'Sugammadex', 'Dexamethasone', 'Rilpivirine (Edurant®)', 
    'Pregabalin', 'Metformin/Sitagliptin', 'Oseltamivir', 'Ropinirole', 'Aspirin', 'Ipratropium Bromide', 'Didanosine', 'Mirtazapine', 'Mitotane', 'Methotrexate', 
    'Pioglitazone', 'Emtricitabine (Emtriva®)', 'Prozac', 'Levetiracetam', 'Oxycodone/Acetaminophen', 'Furosemide', 'Hydrocortisone', 'Clobetasol Propionate', 
    'Clotrimazole/Betamethasone', 'Dorzolamide/Timolol', 'Escitalopram', 'Estrogens Conjugated', 'Nystatin', 'Zoloft', 'Spironolactone', 'Imatinib', 
    'Cyclobenzaprine', 'Fluticasone Furoate', 'Sorafenib', 'Estropipate', 'Diphenhydramine', 'Morphine', 'Vorinostat', 'Sumatriptan', 'Carboplatin', 
    'Elvitegravir / cobicistat / emtricitabine / tenofovir (Stribild®)', 'Warfarin', 'Citalopram', 'Gemtuzumab ozogamicin', 'Linezolid', 'Cefaclor', 
    'Fluticasone', 'Fluconazole', 'Diclofenac', 'Lamivudine', 'Candesartan', 'Penicillin VK', 'Ritonavir', 'Lorazepam', 'Acyclovir', 'Temozolomide', 
    'Sildenafil Citrate', 'Benzonatate', 'Cefdinir', 'Triamcinolone', 'Erythromycin', 'Lisdexamfetamine', 'Cetirizine Hydrochloride', 'Trazodone', 'Cyclosporine', 
    'Itraconazole', 'Hydromorphone', 'Cisplatin', 'Dopamine', 'Triamcinolone Acetonide', 'Amoxicillin', 'Dobutamine', 'Hydrocodone with acetaminophen', 
    'Crizanlizumab', 'Nelfinavir', 'Acetaminophen', 'Labetalol', 'Gemcitabine', 'Fluocinonide', 'Sirolimus', 'Acyclovir Topical', 'Bupropion', 'Dactinomycin', 
    'Famotidine', 'Ethinyl Estradiol/Norethindrone', 'Ganciclovir', 'Alendronate', 'Phenytoin', 'Estradiol Patch', 'Desmopressin (Stimate®)','Norepinephrine', 'Levofloxacin', 'Meloxicam', 'Mycophenolate mofetil', 'Phentermine', 'Valproic acid', 'Efavirenz', 
    'Amitriptyline', 'Dinutuximab', 'Doxycycline Hyclate', 'Zidovudine / Lamivudine (Combivir®)', 'Isosorbide Mononitrate', 'Cephalexin', 'Losartan', 
    'Metronidazole Vaginal Gel', 'Baclofen', 'Lidocaine', 'Fidaxomicin', 'Vincristine', 'Ezetimibe', 'Thiotepa', 'Granisetron', 'Amoxicillin/Clavulanate', 'Posaconazole', 'Pegfilgrastim', 'Amiodarone', 'Ruxolitinib', 'Immune globulin', 'Hydroxyurea']




start_date = datetime.date(2022, 1, 1)
end_date = datetime.date(2023, 12, 31)
num_dates = 150  
manufacturing_dates = []
for _ in range(num_dates):
    random_date = start_date + timedelta(days=random.randint(0, (end_date - start_date).days))
    manufacturing_dates.append(random_date.strftime("%Y-%m-%d"))


start_date2 = datetime.date(2026, 1, 1)
end_date2 = datetime.date(2027, 12, 31)
num_dates2 = 150  
expiry_dates = []
for _ in range(num_dates2):
    random_date2 = start_date2 + timedelta(days=random.randint(0, (end_date2 - start_date2).days))
    expiry_dates.append(random_date2.strftime("%Y-%m-%d"))


def Stock_Records(i):

       random_ID =unique_medIDs[i]
       random_name = medicines_names[i]
       random_quantity = 0
       random_costprice = round(random.uniform(20.0, 150.0), 2)
       random_saleprice = random_costprice+ round(random.uniform(10.0, 25.0), 2)
       random_manuDate=random.choice(manufacturing_dates)  
       random_expiryDate=random.choice(expiry_dates)        
       params = (random_ID, random_name, random_quantity,random_costprice,random_saleprice,random_manuDate,random_expiryDate)
       cursor.execute("EXEC InsertMedStock ?, ?, ?, ?, ?, ?, ?", params)

       conn.commit()


i=-1
[Stock_Records(i := i + 1) for _ in range(300)]
# --------------------------------------------------------------------------------------------------------------------------------------------------


prefixforSup = "CMP"
def generate_cmpID(count):
    cmpIDs = [f"{prefixforSup}{i}" for i in range(1, count + 1)]
    return cmpIDs

unique_cmpIDs = generate_cmpID(30)

medicine_companies = [
    "Alpha Pharmaceuticals", "Beta Biotech", "Gamma Generics", "Delta Drug Co.", "Epsilon Enterprises",
    "Zeta Medicines", "Eta Healthcare", "Theta Therapeutics", "Iota Labs", "Kappa Pharma",
    "Lambda Lifesciences", "Mu Medical", "Nu Nutraceuticals", "Xi Xenobiotics", "Omicron Organics",
    "Pi Pharmaceuticals", "Rho Remedies", "Sigma Solutions", "Tau Treatments", "Upsilon Urology",
    "Phi Pharmaceuticals", "Chi Chemicals", "Psi Prescriptions", "Omega Omeprazole Inc.", "Zenith Pharmaceuticals",
    "Apex Biotech", "Pinnacle Pharmaceuticals", "Summit Health", "Peak Pharmaceuticals", "Vertex Ventures"
]

medCompanyEmails = [
    "alphapharmaceuticals@gmail.com", "betabiotech@gmail.com", "gammagenerics@gmail.com", "deltadrugco@gmail.com",
    "epsilonenterprises@gmail.com", "zetamedicines@gmail.com", "etahealthcare@gmail.com", "thatatherapeutics@gmail.com",
    "iotalabs@gmail.com", "kappapharma@gmail.com", "lambdalifesciences@gmail.com", "mumedical@gmail.com",
    "nunutraceuticals@gmail.com", "xixenobiotics@gmail.com", "omicronorganics@gmail.com", "pipharmaceuticals@gmail.com",
    "rhoremedies@gmail.com", "sigmasolutions@gmail.com", "tautreatments@gmail.com", "upsilonurology@gmail.com",
    "phipharmaceuticals@gmail.com", "chichemicals@gmail.com", "psiprescriptions@gmail.com", "omegaomeprazoleinc@gmail.com",
    "zenithpharmaceuticals@gmail.com", "apexbiotech@gmail.com", "pinnaclepharmaceuticals@gmail.com", "summithealth@gmail.com",
    "peakpharmaceuticals@gmail.com", "vertexventures@gmail.com"
]

medCompanyaddresses = [
    "Street No. 5, Sector G-8, Islamabad", "Block A, Clifton, Karachi", "Model Town, Lahore",
    "Gulshan-e-Iqbal, Peshawar", "F-10 Markaz, Islamabad", "Defense Housing Society, Lahore",
    "Phase 4, Hayatabad, Peshawar", "Main Boulevard, Gulberg, Lahore", "Model Town, Rawalpindi",
    "Cantt Area, Karachi", "Bahria Town, Islamabad", "Satellite Town, Quetta",
    "F-6/1, Islamabad", "Gulshan-e-Maymar, Karachi", "Model Town, Multan",
    "Phase 2, DHA, Lahore", "Cantt Area, Rawalpindi", "Gulistan-e-Jauhar, Karachi",
    "Sector I-8, Islamabad", "University Town, Peshawar", "Saddar, Karachi",
    "Block B, Johar Town, Lahore", "Gulberg, Islamabad", "Block C, North Nazimabad, Karachi",
    "Cantonment, Hyderabad", "Phase 3, Hayatabad, Peshawar", "F-7, Islamabad",
    "Askari Housing Scheme, Lahore", "Model Colony, Karachi", "Civil Lines, Multan"
]

def Company_Records(i):

       random_ID =unique_cmpIDs[i]
       random_name = medicine_companies[i]
       random_email = medCompanyEmails[i]
       random_addresses =medCompanyaddresses[i]
        
       params = (random_ID, random_name,random_email,random_addresses)
       cursor.execute("EXEC InsertIntoSupplier ?, ?, ?, ?", params)

       conn.commit()


i=-1
[Company_Records(i := i + 1) for _ in range(30)]
# -----------------------------------------------------------------------------------------------------------------------------------------

purchaseOrderprefix = "PUR"
def generate_PurchaseID(count):
    PurchaseIDs = [f"{purchaseOrderprefix}{i}" for i in range(1, count + 1)]
    return PurchaseIDs

unique_PurchaseIDs = generate_PurchaseID(700)

purSTARTdate = datetime.date(2021, 1, 1)
purENDdate = datetime.date(2024, 3, 31)
num_dates = 200
purorder_dates = []
for _ in range(num_dates):
    random_date = purSTARTdate + timedelta(days=random.randint(0, (purENDdate - purSTARTdate).days))
    purorder_dates.append(random_date.strftime("%Y-%m-%d"))


def randomTimeForPurchaseOrder():
   start_time = time(8, 0, 0)  
   end_time = time(18, 0, 0)   

   random_time = time(random.randint(start_time.hour, end_time.hour),
                   random.randint(0, 59),
                   random.randint(0, 59))

   formatted_random_time = random_time.strftime('%H:%M:%S')
   return formatted_random_time

def PurchaseOrders(i):

       random_purchaseID =unique_PurchaseIDs[i]
       random_cmpID = random.choice(unique_cmpIDs)
       amount=0
       orderDate=random.choice(purorder_dates)  
       orderTime=randomTimeForPurchaseOrder()        
       params = (random_purchaseID, random_cmpID, amount,orderDate,orderTime)
       cursor.execute("EXEC InsertIntoPurchaseOrder ?, ?, ?, ?, ?", params)

       conn.commit()


i=-1
[PurchaseOrders(i := i + 1) for _ in range(700)]
# -------------------------------------------------------------------------------------------------------------------------------------------------
# create table PurchasedMedicine(
# PurchaseID varchar(30) constraint fk_pruOrders references PurchaseOrder(PurchaseID),
# MedCode varchar(30) constraint fk_pruMedstock references Medicine_Stock(Med_Code),
# Quantity int not null,
# PricePerUnit float,
# );
def PurchasedMedicines(i):

       random_prID =unique_PurchaseIDs[i]
       temp=random.randint(5,8)
       for _ in range(temp):
         random_med = random.choice(unique_medIDs)
         Quantity=random.randint(200,500)
         params = (random_prID, random_med, Quantity)
         cursor.execute("EXEC InsertPurMedicine ?, ?, ?", params)

       conn.commit()


i=-1
[PurchasedMedicines(i := i + 1) for _ in range(700)]


# # ----------------------------------------------------------------------------------------------------------------------------------------------------

Orderprefix = "ODR"
def generate_OrderID(count):
    OrderIDs = [f"{Orderprefix}{i}" for i in range(1, count + 1)]
    return OrderIDs

unique_OrderIDs = generate_OrderID(4000) 

HCServices = ['Vaccination', 'BP-Check']  

OrderSTARTdate = datetime.date(2021, 1, 1)
OrderENDdate = datetime.date(2024, 3, 31)
num_dates = 1000
order_dates = []
for _ in range(num_dates):
    random_date = OrderSTARTdate + timedelta(days=random.randint(0, (OrderENDdate - OrderSTARTdate).days))
    order_dates.append(random_date.strftime("%Y-%m-%d"))

def randomTimeForOrder():
   start_time = time(8, 0, 0)  
   end_time = time(18, 0, 0)   

   random_time = time(random.randint(start_time.hour, end_time.hour),
                   random.randint(0, 59),
                   random.randint(0, 59))

   formatted_random_time = random_time.strftime('%H:%M:%S')
   return formatted_random_time



def Cus_SalesOrders(i):

       random_orderID =unique_OrderIDs[i]
       random_emp = random.choice(unique_empIDs)
       random_cus=random.choice(unique_cnic_list)
       HCS1 = HCServices[0] if random.choice([True, False]) else None
       HCS2 = HCServices[1] if random.choice([True, False]) else None
       medprice=0.0 
       orderDate=random.choice(order_dates)  
       orderTime=randomTimeForOrder()        
       params = (random_orderID, random_emp, random_cus,HCS1,HCS2,medprice,orderDate,orderTime)
       cursor.execute("EXEC InsertCusSalesOrder ?, ?, ?, ?, ?, ?, ?, ?", params)

       conn.commit()


i=-1
[Cus_SalesOrders(i := i + 1) for _ in range(4000)]

# ------------------------------------------------------------------------------------------------------------------------

def Cus_OrderedMedicines(i):

       random_orID =unique_OrderIDs[i]
       temp=random.randint(1,4)
       for _ in range(temp):
         random_med = random.choice(unique_medIDs)
         Quantity=random.randint(2,15)
         params = (random_orID, random_med, Quantity)
         cursor.execute("EXEC InsertIntoOrdMedicine ?, ?, ?", params)

       conn.commit()


i=-1
[Cus_OrderedMedicines(i := i + 1) for _ in range(4000)]

# -----------------------------------------------------------------------------------------------------------------------------

branchprefix = "Branch_"
def generate_BranchID(count):
    branchIDs = [f"{branchprefix}{i}" for i in range(1, count + 1)]
    return branchIDs

unique_BranchIDs = generate_BranchID(5) 

branchNames=[
     'Green Pharmacy','Clinix','Umer Pharmacy','Care Pharmacy','Talha Pharmacy'
]
branchemails=['green@gmail.com','Clinix@gmail','umerphar@gmail.com','care124@gmail.com','talhapharmacy@gmail.com']
branchaddresses=['Chaburji,Lahore','Faisalabad','Shahkot','Anarkali,Lahore','Sialkot']

def braches(i):

       random_branchID =unique_BranchIDs[i]
       branchName = branchNames[i]
       branchemail=branchemails[i]
       branchaddres=branchaddresses[i]
       params = (random_branchID, branchName, branchemail,branchaddres)
       cursor.execute("EXEC InsertLocalBranch ?, ?,?, ?", params)

       conn.commit()


i=-1
[braches(i := i + 1) for _ in range(5)]

# -----------------------------------------------------


    # @Local_OrderID varchar(30),
    # @BCode varchar(30),
    # @Payable_Amount float,
    # @OrderDate date,
    # @OrderTime time

LOrderprefix = "L_ODR_"
def generate_LOrderID(count):
    LOrderIDs = [f"{LOrderprefix}{i}" for i in range(1, count + 1)]
    return LOrderIDs  
unique_LOrderIDs = generate_LOrderID(437) 

LOrderSTARTdate = datetime.date(2021, 1, 1)
LOrderENDdate = datetime.date(2024, 3, 31)
num_dates = 400
Lorder_dates = []
for _ in range(num_dates):
    random_date = LOrderSTARTdate + timedelta(days=random.randint(0, (LOrderENDdate - LOrderSTARTdate).days))
    Lorder_dates.append(random_date.strftime("%Y-%m-%d"))

def randomTimeForLOrder():
   start_time = time(8, 0, 0)  
   end_time = time(18, 0, 0)   

   random_time = time(random.randint(start_time.hour, end_time.hour),
                   random.randint(0, 59),
                   random.randint(0, 59))

   formatted_random_time = random_time.strftime('%H:%M:%S')
   return formatted_random_time


def branchOrders(i):

       random_odid =unique_LOrderIDs[i]
       branID = random.choice(unique_BranchIDs)
       amount=0.0
       Ldate=random.choice(Lorder_dates)
       Ltime=randomTimeForLOrder()
       params = (random_odid, branID, amount,Ldate,Ltime)
       cursor.execute("EXEC InsertLocalSalesOrder ?, ?,?,?, ?", params)

       conn.commit()


i=-1
[branchOrders(i := i + 1) for _ in range(437)]
# ____________________________________________________________________________________________________________________


#  @LOrderID varchar(30),
#     @MedCode varchar(30),
#     @Quantity int


def Loc_OrderedMedicines(i):

       random_orID =unique_LOrderIDs[i]
       temp=random.randint(1,4)
       for _ in range(temp):
         random_med = random.choice(unique_medIDs)
         Quantity=random.randint(100,200)
         params = (random_orID, random_med, Quantity)
         cursor.execute("EXEC InsertIntoLocOrdMedicine ?, ?, ?", params)

       conn.commit()


i=-1
[Loc_OrderedMedicines(i := i + 1) for _ in range(437)]



# ----------------------------------------------------------------------------------------------





   






