using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Windows.Forms;
//Add MySql Library
using MySql.Data.MySqlClient;
using System.IO;
using System.Diagnostics;
using System.Data;
using UtilityLib;
using System.Collections.Specialized;
using System.Data.OleDb;

namespace UtilityLib
{
    class DBConnect
    {
        private MySqlConnection conMySql;
        private SqlConnection conSqlServer;
        private string strServer;
        private string strPort;
        private string strDatabase;
        private string strUid;
        private string strPassword;
        private string strDBType;


        //Constructor
        public DBConnect(string strDBType_)
        {
            strDBType = strDBType_;
            Initialize();
        }
        public SqlConnection getSqlConnection()
        {
            return conSqlServer;
        }

        //Initialize values
        private void Initialize()
        {
            if (strDBType == "MySQL")
            {
                strServer = ConfigHelper.GetAppConfig("MySQLServer", "MySQLConnectionStrings");
                strPort = ConfigHelper.GetAppConfig("MySQLPort", "MySQLConnectionStrings");
                strDatabase = ConfigHelper.GetAppConfig("MySQLDBName", "MySQLConnectionStrings");
                strUid = ConfigHelper.GetAppConfig("MySQLUserName", "MySQLConnectionStrings");
                strPassword = ConfigHelper.GetAppConfig("MySQLPassword", "MySQLConnectionStrings"); 

                string strConnectionString;
                strConnectionString = "SERVER=" + strServer + ";" + "PORT = " + strPort + ";" + "DATABASE=" + strDatabase + ";" + "User ID=" + strUid + ";" + "PASSWORD=" + strPassword + ";";
                conMySql = new MySqlConnection(strConnectionString);
            }
            else if (strDBType == "SQLServer")
            {

                strServer = ConfigHelper.GetAppConfig("SQLServer", "SQLServerConnectionStrings");
                strDatabase = ConfigHelper.GetAppConfig("SQLServerDBName", "SQLServerConnectionStrings");
                strUid = ConfigHelper.GetAppConfig("SQLServerUserName", "SQLServerConnectionStrings");
                strPassword = ConfigHelper.GetAppConfig("SQLServerPassword", "SQLServerConnectionStrings"); 

                string strConnectionString;
                strConnectionString = "SERVER=" + strServer + ";" + "DATABASE=" + strDatabase + ";" + "User ID=" + strUid + ";" + "PASSWORD=" + strPassword + ";";

                conSqlServer = new SqlConnection(strConnectionString);
            }
            
        }


        //open connection to database
        private bool OpenConnection()
        {
            try
            {
                if (strDBType == "MySQL")
                {
                    conMySql.Open();
                }
                else
                {
                    if (conSqlServer.State.ToString() != "Open")
                    {
                        conSqlServer.Open(); 
                    }                                      
                }
                return true;
            }
            catch (MySqlException ex)
            {
                //When handling errors, the application's response is based on the error number.
                //The two most common error numbers when connecting are as follows:
                //0: Cannot connect to server.
                //1045: Invalid user name and/or password.
                switch (ex.Number)
                {
                    case 0:
                        MessageBox.Show("Cannot connect to server.  Contact administrator");
                        break;

                    case 1045:
                        MessageBox.Show("Invalid username/password, please try again");
                        break;
                }
                return false;
            }
            catch (SqlException ex)
            {
                return false;
                throw new Exception("OpenConnection: " + ex.Message);
            }      
        }

        //Close connection
        private bool CloseConnection()
        {
            try
            {
                if (strDBType == "MySQL")
                {
                    conMySql.Close();
                }
                else
                {
                    conSqlServer.Close();
                }
                
                return true;
            }
            catch (MySqlException ex)
            {
                return false;
                throw new Exception("CloseConnection: " + ex.Message);
            }
            catch (SqlException ex)
            {
                return false;
                throw new Exception("CloseConnection: " + ex.Message);
            }
        }
        //
        public SqlDataReader Read(string strQuery)
        {
            try
            {
               this.OpenConnection();
               SqlCommand myCommand = new SqlCommand(strQuery, conSqlServer);
               SqlDataReader myReader = myCommand.ExecuteReader();
               return myReader;
            }
      
            catch (SqlException ex)
            {
                this.CloseConnection();
                return null;
                throw new Exception("Read: " + ex.Message);
            }
        }
        //Insert statement
        public void Insert(string strQuery)
        {
            //string query = "INSERT INTO tableinfo (name, age) VALUES('John Smith', '33')";
            try
            {
                if (strDBType == "MySQL")
                {
                    InsertDBMySql(strQuery);
                }
                else
                {
                    InsertDBSqlServer(strQuery);
                }
            }      
             catch (MySqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Insert: " + ex.Message);
            }
            catch (SqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Insert: " + ex.Message);
            }
        }

        // Overload function for batch insert (more than 500 sentences)
        public void Insert(List<string> strQueryList)
        {
            //List<string> strQueryList includes several SQL insert query.
            //Do insert action every 500 insert sentences.
            try
            {
                if (strDBType == "MySQL" && strQueryList.Count == 1)
                {
                    InsertDBMySql(strQueryList[0]);
                }
                else
                {
                    BatchInsertDBMySql(strQueryList);
                }
            }
            catch (MySqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Insert: " + ex.Message);
            }
            catch (SqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Insert: " + ex.Message);
            }
        }

        // Overload function for batch insert (SQL Server Type)
        public void Insert(DataTable dtInput, string strTableName)
        {
            try
            {
                if (strDBType == "SQLServer")
                {
                    BatchInsertDBSqlServer(dtInput, strTableName);
                }
            }
            catch (MySqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Insert: " + ex.Message);
            }
            catch (SqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Insert: " + ex.Message);
            }
        }


        public void BatchInsertDBMySql(List<string> strQueryList)
        {
            // DO insert every 500 sentences.
            conMySql.Open();

            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = conMySql;
            
            MySqlTransaction tx = conMySql.BeginTransaction();
            cmd.Transaction = tx;

            for (int n = 0; n < strQueryList.Count; n++)
            {
                string strQuery = strQueryList[n].ToString();
                if (strQuery.Trim().Length > 1)
                {
                    cmd.CommandText = strQuery;
                    cmd.ExecuteNonQuery();
                }

                if (n > 0 && (n % 100 == 0 || n == strQueryList.Count - 1))
                {
                    tx.Commit();
                    tx = conMySql.BeginTransaction();
                }
            }
        }

        public void BatchInsertDBSqlServer(DataTable dtInput, string strTableName)
        {
            //Use bulkcopy to improve the function.
            SqlBulkCopy bulkCopy = new SqlBulkCopy(conSqlServer);
            bulkCopy.DestinationTableName = strTableName;
            bulkCopy.BatchSize = dtInput.Rows.Count;

            if (dtInput != null && dtInput.Rows.Count != 0)
            {
                bulkCopy.WriteToServer(dtInput);
            }

            conSqlServer.Close();
            if (bulkCopy != null)
            {
                bulkCopy.Close();
            }
        }

        private void InsertDBMySql(string strQuery)
        {
            if (this.OpenConnection() == true)
            {
                //create command and assign the query and connection from the constructor
                MySqlCommand cmd = new MySqlCommand(strQuery, conMySql);

                //Execute command
                cmd.ExecuteNonQuery();
            }

            //close connection
            this.CloseConnection();
        }

        private void InsertDBSqlServer(string strQuery)
        {
            if (this.OpenConnection() == true)
            {
                //create command and assign the query and connection from the constructor
                SqlCommand cmd = new SqlCommand(strQuery, conSqlServer);

                //Execute command
                cmd.ExecuteNonQuery();
            }

            //close connection
            this.CloseConnection();
        }


        //Update statement
        public void Update(string strQuery)
        {
            //string query = "UPDATE tableinfo SET name='Joe', age='22' WHERE name='John Smith'";
            try
            {
                if (strDBType == "MySQL")
                {
                    UpdateDBMySql(strQuery);
                }
                else
                {
                    UpdateDBSqlServer(strQuery);
                }
            }
            catch (MySqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Update: " + ex.Message);
            }
            catch (SqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Update: " + ex.Message);
            }
        }

        private void UpdateDBMySql(string strQuery)
        {
            //Open connection
            if (this.OpenConnection() == true)
            {
                //create mysql command
                MySqlCommand cmd = new MySqlCommand();
                //Assign the query using CommandText
                cmd.CommandText = strQuery;
                //Assign the connection using Connection
                cmd.Connection = conMySql;
                //Execute query
                cmd.ExecuteNonQuery();
            }

            //close connection
            this.CloseConnection();
        }

        private void UpdateDBSqlServer(string strQuery)
        {
            //Open connection
            if (this.OpenConnection() == true)
            {
                //create Sql command
                SqlCommand cmd = new SqlCommand();
                //Assign the query using CommandText
                cmd.CommandText = strQuery;
                //Assign the connection using Connection
                cmd.Connection = conSqlServer;
                //Execute query
                cmd.ExecuteNonQuery();
            }

            //close connection
            this.CloseConnection();
        }

        //Delete statement
        public void Delete(string strQuery)
        {
            //string query = "DELETE FROM tableinfo WHERE name='John Smith'";
            try
            {
                if (strDBType == "MySQL")
                {
                    DeleteDBMySql(strQuery);
                }
                else
                {
                    DeleteDBSqlServer(strQuery);
                }
            }
            catch (MySqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Delete: " + ex.Message);
            }
            catch (SqlException ex)
            {
                this.CloseConnection();
                throw new Exception("Delete: " + ex.Message);
            }
        }

        private void DeleteDBMySql(string strQuery)
        {
            if (this.OpenConnection() == true)
            {
                MySqlCommand cmd = new MySqlCommand(strQuery, conMySql);
                cmd.ExecuteNonQuery();
            }

            this.CloseConnection();
        }

        private void DeleteDBSqlServer(string strQuery)
        {
            if (this.OpenConnection() == true)
            {
                SqlCommand cmd = new SqlCommand(strQuery, conSqlServer);
                cmd.ExecuteNonQuery();
            }

            this.CloseConnection();
        }


        //Select statement
        public DataSet Select(string strQuery)
        {

            DataSet dsOutputData = new DataSet();

            if (strDBType == "MySQL")
            {
                dsOutputData = SelectDBMySql(strQuery, conMySql);
            }
            else
            {
                dsOutputData = SelectDBSqlServer(strQuery, conSqlServer);
            }
                
            //return list to be displayed
            return dsOutputData;
            
        }

        private DataSet SelectDBMySql(string strQuery, MySqlConnection conMySql)
        {
            DataSet dsOutputData = new DataSet();

            //Open connection
            if (this.OpenConnection() == true)
            {
                //Create a data adapter and Execute the command
                MySqlDataAdapter dataAdapter = new MySqlDataAdapter(strQuery, conMySql);

                //Read the data and store them in dataset
                dataAdapter.Fill(dsOutputData);

                //close data adapter
                dataAdapter.Dispose();
            }

            //close Connection
            this.CloseConnection();

            //return list to be displayed
            return dsOutputData;
        }

        private DataSet SelectDBSqlServer(string strQuery, SqlConnection conSqlServer)
        {
            DataSet dsOutputData = new DataSet();

            //Open connection
            if (this.OpenConnection() == true)
            {
                //Create a data adapter and Execute the command
                SqlDataAdapter dataAdapter = new SqlDataAdapter(strQuery, conSqlServer);

                //Read the data and store them in dataset
                dataAdapter.Fill(dsOutputData);

                //close data adapter
                dataAdapter.Dispose();
            }

            //close Connection
            this.CloseConnection();

            //return list to be displayed
            return dsOutputData;
        }

        //Count statement
        public int Count()
        {
            string query = "SELECT Count(*) FROM tableinfo";
            int Count = -1;

            if (strDBType == "MySQL")
            {
                Count = CountDBMySql(query, conMySql);
            }
            else
            {
                Count = CountDBSqlServer(query, conSqlServer);
            }
                
            return Count;
        }

        private int CountDBMySql(string query, MySqlConnection conMySql)
        {
            int Count = -1;

            if (this.OpenConnection() == true)
            {
                //Create Mysql Command
                MySqlCommand cmd = new MySqlCommand(query, conMySql);

                //ExecuteScalar will return one value
                Count = int.Parse(cmd.ExecuteScalar() + "");

                //close Connection
                this.CloseConnection();
            }

            return Count;
        }

        private int CountDBSqlServer(string query, SqlConnection conSqlServer)
        {
            int Count = -1;

            if (this.OpenConnection() == true)
            {
                //Create Sql Command
                SqlCommand cmd = new SqlCommand(query, conSqlServer);

                //ExecuteScalar will return one value
                Count = int.Parse(cmd.ExecuteScalar() + "");

                //close Connection
                this.CloseConnection();
            }

            return Count;
        }

        //Backup
        public void Backup()
        {
            try
            {
                DateTime Time = DateTime.Now;
                int year = Time.Year;
                int month = Time.Month;
                int day = Time.Day;
                int hour = Time.Hour;
                int minute = Time.Minute;
                int second = Time.Second;
                int millisecond = Time.Millisecond;

                //Save file to C:\ with the current date as a filename
                string path;
                path = "C:\\" + year + "-" + month + "-" + day + "-" + hour + "-" + minute + "-" + second + "-" + millisecond + ".sql";
                StreamWriter file = new StreamWriter(path);


                ProcessStartInfo psi = new ProcessStartInfo();
                psi.FileName = "mysqldump";
                psi.RedirectStandardInput = false;
                psi.RedirectStandardOutput = true;
                psi.Arguments = string.Format(@"-u{0} -p{1} -h{2} {3}", strUid, strPassword, strServer, strDatabase);
                psi.UseShellExecute = false;

                Process process = Process.Start(psi);

                string output;
                output = process.StandardOutput.ReadToEnd();
                file.WriteLine(output);
                process.WaitForExit();
                file.Close();
                process.Close();
            }
            catch (IOException ex)
            {
                throw new Exception("Backup: " + ex.Message);
            }
        }

        //Restore
        public void Restore()
        {
            try
            {
                //Read file from C:\
                string path;
                path = "C:\\MySqlBackup.sql";
                StreamReader file = new StreamReader(path);
                string input = file.ReadToEnd();
                file.Close();


                ProcessStartInfo psi = new ProcessStartInfo();
                psi.FileName = "mysql";
                psi.RedirectStandardInput = true;
                psi.RedirectStandardOutput = false;
                psi.Arguments = string.Format(@"-u{0} -p{1} -h{2} {3}", strUid, strPassword, strServer, strDatabase);
                psi.UseShellExecute = false;


                Process process = Process.Start(psi);
                process.StandardInput.WriteLine(input);
                process.StandardInput.Close();
                process.WaitForExit();
                process.Close();
            }
            catch (IOException ex)
            {
                throw new Exception("Restore: " + ex.Message);
            }
        }
    }
}