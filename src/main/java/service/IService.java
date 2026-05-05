package service;

import java.util.List;

public interface IService <T>{
    void add(T t);
    List<T> getAll();
    T getById(int id);
    void update(int id, T t);
    void delete(int id);
}
