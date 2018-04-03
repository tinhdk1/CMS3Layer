﻿using System;
namespace MyCms.Data
{
    public class UserDAO : SqlDataProvider
    {

        #region[User_GetByAll]
        /// Lấy thông tin user
        /// </summary>
        /// <returns></returns>
        {
            List<Data.User> list = new List<Data.User>();
            using (SqlCommand dbCmd = new SqlCommand("sp_User_GetByAll", GetConnection()))
            {
                Data.User obj = new Data.User();
                dbCmd.CommandType = CommandType.StoredProcedure;
                SqlDataReader dr = dbCmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        list.Add(obj.UserIDataReader(dr));
                    }

                }
                dr.Close();
                obj = null;
            }
            return list;
        }
        #endregion
    }
}